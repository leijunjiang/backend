require 'bigdecimal'
class Buyer
  attr_accessor :euro_balance, :btc_balance
  def initialize(hash)
    @euro_balance = BigDecimal(hash[:euro].to_s)
    @btc_balance  = BigDecimal(hash[:btc].to_s)
  end

  def buyer?
    self.class.name == "Buyer"
  end

  def seller?
    self.class.name == "Seller"
  end
end