require_relative './order'

class Market
  def initialize
    @order_id = 0

    @bids = {}

    @buy_prices = {}
    @buy_max = -Float::INFINITY

    @asks = {}

    @sell_prices = {}
    @sell_min = Float::INFINITY
  end

  def submit(order)
    @order_id += 1

    if order.buy?
      @bids[@order_id.to_s] = [order.price_to_s, order.amount_to_s]
      @buy_max = [order.price, @buy_max].max
      @buy_prices[@order_id.to_s] = order.price
    else
      @asks[@order_id.to_s] = [order.price_to_s, order.amount_to_s]
      @sell_min = [order.price, @sell_min].min
      @sell_prices[@order_id.to_s] = order.price
    end

    @order_id
  end

  def market_price
    market_price = (@buy_max + @sell_min) / 2
    format('%.1f', market_price)
  end

  def market_depth
    bids = @bids.values
    asks = @asks.values

    {
      bids: bids,
      base: 'BTC',
      quote: 'EUR',
      asks: asks
    }
  end

  def cancel_order(id)
    can_cancel_order = false
    if @bids[id.to_s]
      @bids.delete(id.to_s)
      @buy_prices.delete(id.to_s)
      @buy_max = @buy_prices.values.max
      can_cancel_order = true
    elsif @asks[id.to_s]
      @asks.delete(id.to_s)
      @sell_prices.delete(id.to_s)
      @sell_min = @sell_prices.values.min
      can_cancel_order = true
    end
    can_cancel_order
  end
end
