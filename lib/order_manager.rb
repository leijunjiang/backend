require 'bigdecimal'
class OrderManager
  attr_accessor :bid_orders, :ask_orders, :bid_prices, :ask_prices

  attr_reader :order_id, :bid_max, :ask_min

  def initialize()
    @order_id = 0

    @bid_orders = {}
    @ask_orders = {}

    @bid_prices = {}
    @ask_prices = {}

    @bid_max = -Float::INFINITY
    @ask_min = Float::INFINITY
  end

  def add(order)
    if order.bid?
      bid_orders[@order_id.to_s] = [order.price_to_s, order.amount_to_s]
      bid_prices[@order_id.to_s] = order.price
      @bid_max = [order.price, @bid_max].max
      @order_id += 1
    elsif order.ask?
      ask_orders[@order_id.to_s] = [order.price_to_s, order.amount_to_s]
      ask_prices[@order_id.to_s] = order.price

      @ask_min = [order.price, @ask_min].min
      @order_id += 1
    end

    @order_id
  end

  def matchable?
    bid_max == ask_min && !bid_orders.empty? && !ask_orders.empty?
  end

  def trade
    bid_order_id , bid_max_price = bid_prices.max_by{|k,v| v}
    ask_order_id , ask_min_price = ask_prices.min_by{|k,v| v}
    cancel_order bid_order_id
    cancel_order ask_order_id

    bid_max_price
  end

  def cancel_order(id)
    can_cancel_order = false
    if bid_orders[id.to_s]
      bid_orders.delete(id.to_s)
      bid_prices.delete(id.to_s)
      @bid_max = bid_prices.values.max
      can_cancel_order = true
    elsif ask_orders[id.to_s]
      ask_orders.delete(id.to_s)
      ask_prices.delete(id.to_s)
      @ask_min = ask_prices.values.min
      can_cancel_order = true
    end

    can_cancel_order
  end
end