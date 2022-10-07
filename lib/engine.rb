require_relative './order'
require_relative './order_manager'
require_relative './account_manager'
require_relative './market'

class Engine
  FEE_RATE = "0.0025"

  attr_reader :market, :order_manager

  def initialize(market)
    @market = market
    @order_manager = OrderManager.new
  end

  def add_order(order)
    order_manager.add(order)
  end

  def cancel_order(id)
    order_manager.cancel_order(id)
  end

  def submit(order)
    add_order(order)
    
    order_manager.order_id
  end

   def match
    h = Hash.new(0)
    match_rec(h)
    h[:count]
  end

  def match_rec(h)
    if order_manager.matchable?
      price = order_manager.trade
      if account_manager.transfert(market.base, market.quote, price)
        h[:count] += 1

        match_rec(h)
      end
    end
  end

  def market_depth
    {
      bids: order_manager.bid_orders.select{|id, order| order.created?}.values.map(&:price_amount_to_s),
      base: market.base,
      quote: market.quote,
      asks: order_manager.ask_orders.select{|id, order| order.created?}.values.map(&:price_amount_to_s)
    }
  end

  def market_price
    market_price = (order_manager.bid_max + order_manager.ask_min) / 2
    format('%.1f', market_price)
  end

  def cancel_order(id)
    order_manager.cancel_order(id)
  end

  # private
  def account_manager
    @account_manager ||= AccountManager.new(FEE_RATE)
  end
end