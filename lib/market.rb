require_relative './order'
require_relative './order_manager'
require_relative './account_manager'

class Market
  attr_accessor :account_manager, :order_manager

  def initialize
    @account_manager = AccountManager.new()
    @order_manager   = OrderManager.new()
  end

  def add_account(account)
    account_manager.add(account)
  end

  def add_order(order)
    order_manager.add(order)
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
      if account_manager.transfert price
        h[:count] += 1

        match_rec(h)
      end
    end
  end

  def market_price
    market_price = (order_manager.bid_max + order_manager.ask_min) / 2
    format('%.1f', market_price)
  end

  def market_depth
    {
      bids: order_manager.bid_orders.values,
      base: 'BTC',
      quote: 'EUR',
      asks: order_manager.ask_orders.values

    }
  end

  def cancel_order(id)
    order_manager.cancel_order(id)
  end
end
