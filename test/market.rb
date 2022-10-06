require 'minitest/autorun'
require_relative '../main'
require 'bigdecimal'

class MarketTest < Minitest::Test
  def test_market_price
    setup_level_1
    assert @market.market_price == "2.5"
  end

  def test_market_depth
    setup_level_1
    assert @market.market_depth == {:bids=>[["1.40", "3.37500000"], ["1.80", "1.50000000"]], 
                                    :base=>"BTC", 
                                    :quote=>"EUR", 
                                    :asks=>[["3.60", "3.37500000"], ["3.20", "1.50000000"]]}
  end

  def test_market_price_after_cancel
    setup_level_1
    @market.cancel_order(3)
    assert @market.market_price == "2.7"
  end

  def test_market_depth_after_cancel
    setup_level_1
    @market.cancel_order(3)
    assert @market.market_depth == {:bids=>[["1.40", "3.37500000"], ["1.80", "1.50000000"]], 
                                    :base=>"BTC", 
                                    :quote=>"EUR", 
                                    :asks=>[["3.60", "3.37500000"]]}
  end

  def setup_level_1
    @market = Market.new
    order_a = Order.new({ amount: 3.375, price: 1.4, side: 'bid' })
    order_b = Order.new({ amount: 3.375, price: 3.6, side: 'ask' })
    order_3 = Order.new({ amount: 1.5, price: 1.8, side: 'bid' })
    order_4 = Order.new({ amount: 1.5, price: 3.2, side: 'ask' })
    @market.submit(order_a)
    @market.submit(order_b)
    @market.submit(order_3)
    @market.submit(order_4)
  end


  def test_level_2_accounts
    setup_level_2
    assert @market.account_manager.bid_balance[:euro] == 45000
    assert @market.account_manager.bid_balance[:btc] == 0
    assert @market.account_manager.ask_balance[:euro] == 0
    assert @market.account_manager.ask_balance[:btc] == 3
  end

  def test_level_2_market_depth
    setup_level_2
    assert @market.market_depth == {:bids=>[["27000.00", "1.00000000"]], 
                                    :base=>"BTC", 
                                    :quote=>"EUR", 
                                    :asks=>[["27000.00", "1.00000000"]]}
  end

  def test_level_2_after_match
    setup_level_2
    match_time = @market.match
    assert match_time == 1
    assert @market.market_depth == {:bids=>[], 
                                    :base=>"BTC", 
                                    :quote=>"EUR", 
                                    :asks=>[]}

    assert @market.account_manager.bid_balance[:euro] == BigDecimal("18000")
    assert @market.account_manager.bid_balance[:btc] == BigDecimal("1")
    assert @market.account_manager.ask_balance[:euro] == BigDecimal("27000")
    assert @market.account_manager.ask_balance[:btc] == BigDecimal("2")
  end



  def setup_level_2
    @market = Market.new
    buyer = Buyer.new({euro: 45000, btc: 0})
    seller = Seller.new({euro: 0, btc: 3})
    @market.add_account(buyer)
    @market.add_account(seller)
    order_a = Order.new({ amount: 1.000, price: 27000, side: 'bid' })
    order_b = Order.new({ amount: 1.000, price: 27000, side: 'ask' })
    @market.submit(order_a)
    @market.submit(order_b)
  end

  def test_level_3_after_match
    setup_level_3
    matcht_times = @market.match

    assert matcht_times == 1
    assert @market.market_depth == {:bids=>[], 
                                    :base=>"BTC", 
                                    :quote=>"EUR", 
                                    :asks=>[]}

    assert @market.account_manager.bid_balance[:euro] == BigDecimal("17966.25")
    assert @market.account_manager.bid_balance[:btc] == BigDecimal("1")
    assert @market.account_manager.ask_balance[:euro] == BigDecimal("26966.25") 
    assert @market.account_manager.ask_balance[:btc] == BigDecimal("2")
    assert @market.account_manager.fee_user_balance == BigDecimal("67.5")

  end

  def setup_level_3
    @market = Market.new(true)
    buyer = Buyer.new({euro: 45000, btc: 0})
    seller = Seller.new({euro: 0, btc: 3})
    @market.add_account(buyer)
    @market.add_account(seller)
    order_a = Order.new({ amount: 1.000, price: 27000, side: 'bid' })
    order_b = Order.new({ amount: 1.000, price: 27000, side: 'ask' })
    @market.submit(order_a)
    @market.submit(order_b)
  end
end