require 'bigdecimal'
class Seller
  attr_accessor :balance
  def initialize(hash)
    @balance = hash.transform_values {|v| BigDecimal(v.to_s)}
  end

  def to_h
    balance
  end

  def buyer?
    self.class.name == "Buyer"
  end

  def seller?
    self.class.name == "Seller"
  end
end