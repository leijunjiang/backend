require 'bigdecimal'
class AccountManager
  attr_accessor :bid_balance, :ask_balance
  attr_reader :fee_rate

  @@bid_balance = Hash.new(BigDecimal('0'))
  @@ask_balance = Hash.new(BigDecimal('0'))


  def initialize(fee_rate = 0)
    @fee_rate = fee_rate
  end

  def to_h
    {
      bid_balance: @@bid_balance,
      ask_balance: @@ask_balance
    }
  end

  def add(account)
    if account.buyer?
      account.to_h.each do |currency, amount|
        @@bid_balance[currency] += amount
      end
    elsif account.seller?
      account.to_h.each do |currency, amount|
        @@ask_balance[currency] += amount
      end
    end
  end

  def transfert(base, quote, price, amount = BigDecimal("1"))

    if (@@bid_balance[quote] - (price * amount)) >= 0 && (@@ask_balance[base] - amount) >= 0
      @@bid_balance[quote] -= (price * amount)
      @@bid_balance[base]  += amount
      @@ask_balance[quote] += (price * amount)
      @@ask_balance[base]  -= amount

      if fee_rate != 0 
        fee = (price * amount) * BigDecimal(fee_rate)
        @@bid_balance[quote] -= (fee / 2)
        @@bid_balance[:fee] += (fee / 2)

        @@ask_balance[quote] -= (fee / 2)
        @@ask_balance[:fee] += (fee / 2)
      end

      true
    else
      false
    end
  end

  def self.fee_user_balance
    @@bid_balance[:fee] + @@ask_balance[:fee]
  end
end