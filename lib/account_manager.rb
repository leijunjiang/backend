require 'bigdecimal'
class AccountManager
  attr_accessor :bid_balance, :ask_balance
  attr_reader :fee_rate, :enable_fee

  FEE_RATE = "0.0025"

  def initialize(enable_fee = false)
    @bid_balance = Hash.new(BigDecimal('0'))
    @ask_balance = Hash.new(BigDecimal('0'))
    @enable_fee = enable_fee
  end

  def add(account)
    if account.buyer?
      bid_balance[:euro] += account.euro_balance
      bid_balance[:btc]  += account.btc_balance
    elsif account.seller?
      ask_balance[:euro] += account.euro_balance
      ask_balance[:btc] += account.btc_balance
    end
  end

  def transfert(price, amount = BigDecimal("1"))
    if (bid_balance[:euro] - (price * amount)) >= 0 && (ask_balance[:btc] - amount) >= 0
      
      bid_balance[:euro] -= (price * amount)
      bid_balance[:btc]  += amount
      ask_balance[:euro] += (price * amount)
      ask_balance[:btc]  -= amount

      if enable_fee 
        fee = (price * amount) * BigDecimal(FEE_RATE)
        charge fee
      end

      true
    else
      false
    end
  end

  def charge(fee)
    bid_balance[:euro] -= (fee / 2)
    bid_balance[:fee] += (fee / 2)

    ask_balance[:euro] -= (fee / 2)
    ask_balance[:fee] += (fee / 2)
  end

  def fee_user_balance
    bid_balance[:fee] + ask_balance[:fee]
  end
end