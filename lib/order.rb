require 'bigdecimal'

class Order
  CREATED = "created"
  FILLED = "filled"

  attr_accessor :amount, :price, :side
  def initialize(hash)
    @amount = BigDecimal(hash[:amount].to_s)
    @price = BigDecimal(hash[:price].to_s)
    @side =  hash[:side]
    @status = CREATED
  end

  def price_to_s
    format('%.2f', @price)
  end

  def amount_to_s
    format('%.8f', @amount)
  end

  def bid?
    @side == 'bid'
  end

  def ask?
    @side == 'ask'
  end

  def created?
    @status == CREATED
  end

  def filled?
    @status == FILLED
  end

  def fill
    @status = FILLED
  end

  def price_amount_to_s
    [price_to_s, amount_to_s]
  end
end
