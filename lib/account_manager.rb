class AccountManager
  attr_accessor :bid_balance, :ask_balance
  def initialize()
    @bid_balance = Hash.new(0)
    @ask_balance = Hash.new(0)
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

      true
    else
      false
    end
  end
end