require 'bigdecimal'
class Buyer
  attr_accessor :balance
  def initialize(hash)
    @balance = hash.map{|k,v| [k.to_sym, BigDecimal(v.to_s)]}.to_h
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