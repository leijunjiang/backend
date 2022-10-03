require 'bigdecimal'

class Order
  attr_accessor :amount, :price, :side
  def initialize(hash)
    @amount = BigDecimal(hash[:amount].to_s)
    @price = BigDecimal(hash[:price].to_s)
    @side =  hash[:side]
  end

  def price_to_s
    format('%.2f', @price)
  end

  def amount_to_s
    format('%.8f', @amount)
  end

  def buy?
    @side == 'buy'
  end

  def sell?
    @side == 'sell'
  end
end
