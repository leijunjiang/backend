# How to use my solution
## Important

use commit da4591410db66130be778ced4f853c131bd0fa9d to run tests for level 1 , level 2 and level 3

git checkout da4591410db66130be778ced4f853c131bd0fa9d

```ruby
 > ruby ./test/market.rb
```

use main branch for level 4, there is no written tests for level4 , just follow the following instructions


Running `irb` and `require_relative 'main' `

require_relative 'main'

market = Market.new

order_a = Order.new({ amount: 3.375, price: 1.4, side: 'bid' })

order_b = Order.new({ amount: 3.375, price: 3.6, side: 'ask' })

order_3 = Order.new({ amount: 1.5, price: 1.8, side: 'bid' })

order_4 = Order.new({ amount: 1.5, price: 3.2, side: 'ask' })

market.submit(order_a)

market.submit(order_b)

market.submit(order_3)

market.submit(order_4)

pp market.market_price

pp market.market_depth

market.cancel_order(3)

pp market.market_price

pp market.market_depth




# Backend challenge

## Guidelines

- Solve the levels in ascending order
- Only do one commit per level and include the `.git` when submiting your test

## Pointers

You can have a look at the higher levels, but please do the simplest thing that could work for the level you're currently solving.

The levels become more complex over time, so you will probably have to re-use some code and adapt it to the new requirements.
A good way to solve this is by using OOP, adding new layers of abstraction when they become necessary and possibly write tests so you don't break what you have already done.

Don't hesitate to write [shameless code](http://red-badger.com/blog/2014/08/20/i-spent-3-days-with-sandi-metz-heres-what-i-learned/) at first, and then refactor it in the next levels.

For higher levels we are interested in seeing code that is clean, extensible and robust, so don't overlook edge cases, use exceptions where needed, ...

Please also note that:

- All prices and amounts are stored as BigDecimal
- Running `irb` and `require_relative 'main' ` from the level folder must be able to interact with your program but of course feel free to add more files if needed.

## Intro

We want to build a simplified trade engine for exchanging currencies

We have currencies Bitcoin (BTC) and Euro (EUR)

We have one market BTC/EUR (BTC called base currency and EUR called quote currency)
It's possible to add an order to a market to buy or sell BTC. A market maintains 2 dedicated sets to store buy orders (bids) and sell orders (asks).

An order is composed by :

* a btc amount (amount to buy or sell BTC)
* a price (in EUR per BTC)
* a side (buy or sell)

## Level 1

* We can submit multiple 'buy' orders and 'sell' orders to a market.
* We can cancel an order with his id.
* Market depth can be displayed (containing all orders submitted to the market (bids and asks))
* A market provides the market price (it is the average between the first buy order with maximum price and the first sell order with minimum price).

```ruby
  > market.submit(order_a) # buy order with price 1.40 € and btc_amount 3.375
=> 1 # returns order id

  > market.submit(order_b)
=> 2

  > market.market_price
=> 2.5

  > pp market.market_depth
{"bids"=>
  [["2.00", "1.00000000"], # price €, BTC amount
   ["1.80", "1.50000000"],
   ["1.60", "2.25000000"],
   ["1.40", "3.37500000"], # <- here is order_a
   ["1.20", "5.06250000"],
   ["1.00", "7.59375000"],
   ["0.80", "11.39062500"],
   ["0.60", "17.08593750"]],
 "base"=>"BTC",
 "quote"=>"EUR",
 "asks"=>
  [["3.00", "1.00000000"],
   ["3.20", "1.50000000"],
   ["3.40", "2.25000000"],
   ["3.60", "3.37500000"],
   ["3.80", "5.06250000"],
   ["4.00", "7.59375000"],
   ["4.20", "11.39062500"],
   ["4.40", "17.08593750"]]}

  > market.cancel_order(1)
=> true

  > pp market.market_depth
{"bids"=>
  [["2.00", "1.00000000"], 
   ["1.80", "1.50000000"],
   ["1.60", "2.25000000"], 
   ["1.20", "5.06250000"],  # <- order_a is no longer present.
   ["1.00", "7.59375000"],
   ["0.80", "11.39062500"],
   ["0.60", "17.08593750"]],
 "base"=>"BTC",
 "quote"=>"EUR",
 "asks"=>
  [["3.00", "1.00000000"],
   ["3.20", "1.50000000"],
   ["3.40", "2.25000000"],
   ["3.60", "3.37500000"],
   ["3.80", "5.06250000"],
   ["4.00", "7.59375000"],
   ["4.20", "11.39062500"],
   ["4.40", "17.08593750"]]}

```

## Level 2

To use this market a user has a BTC balance and a EUR balance.
An order has an initial state set to 'created'.

The aim of the matching engine is to process orders and to match them. To perform a match we look up the first buy order with maximum price (bids) and the first sell order with minimum price (asks). Two orders match when:

* order sides are different
* if the price of both exactly match
* if the amount of both exactly match (*which will always be 1 to simplify the algorithm*)

For example with BTC/EUR market, when two orders matches, the engine should fill both orders and update user balances:

* both orders state change to 'filled'
* the seller BTC balance is decreased by his sell order BTC amount
* the seller EUR balance is increased by his sell order BTC amount * price
* the buyer BTC balance is increased by his buy order BTC amount
* the buyer EUR balance is decreased by his buy order BTC amount * price
* both orders are removed from the market (asks and bids)

Adapt code to perform matching order.



require_relative 'main'

market = Market.new

buyer = Buyer.new({euro: 45000, btc: 0})
seller = Seller.new({euro: 0, btc: 3})
market.add_account(buyer)
market.add_account(seller)
order_a = Order.new({ amount: 1.000, price: 27000, side: 'bid' })
order_b = Order.new({ amount: 1.000, price: 27000, side: 'ask' })
market.submit(order_a)
market.submit(order_b)
market.match

```ruby
 # buyer EUR balance is 45000 and BTC balance is 0
 # seller BTC balance is 3 and EUR balance is 0
 
  > market.submit(order_a) # order_a buys 1 BTC at 27000€ per BTC
=> 1 # returns order id

  > market.submit(order_b) # order_b sells 1 BTC at 27000€ per BTC
=> 2

  > pp market.market_depth
{"bids"=> [["27000.00", "1.00000000"]],
 "base"=>"BTC",
 "quote"=>"EUR",
 "asks"=> [["27000.00", "1.00000000"]]
}

  > market.match
=> 1 # return number of matches

  > pp market.market_depth
{"bids"=> [],
 "base"=>"BTC",
 "quote"=>"EUR",
 "asks"=> []
}

 # buyer EUR balance is 18000 and BTC balance is 1
 # seller BTC balance is 2 and EUR balance is 27000

```

## Level 3

For each match we want to take a fee. An additional 0.25% from (price * amount) will be debited from seller EUR balance and buyer EUR balance and will be credited on eur balance to a 'fee' user.

Example : 
If there is a match at 1 BTC with 27000€ per BTC then fees are (1 * 27000) * 0.25% = 67.5 euros. Each user contributes (33.75€ per user) to pays this fee to a fee user.

```ruby
# buyer EUR balance is 45000 and BTC balance is 0
# seller BTC balance is 3 and EUR balance is 0
 
  > market.submit(order_a) # order_a buys 1 BTC at 27000€ per BTC
=> 1 # returns order id

  > market.submit(order_b) # order_b sells 1 BTC at 27000€ per BTC
=> 2

 > market.match
=> 1 # return number of matches


 # buyer EUR balance is 17966.25 and BTC balance is 1
 # seller BTC balance is 2 and EUR balance is 26966,25
 # fee user EUR balance is 67.5 €

```

## Level 4

We have a BTC/EUR market with matching engine and we want to have a new market ETH/EUR using the same matching engine.

Adapt your code to reflect this change.

```ruby

irb

 > require_relative "main"

 > market_btc = Market.new({base: "BTC", quote: "EURO"})

 > market_eth = Market.new({base: "ETH", quote: "EURO"})

 > engine_btc = Engine.new(market_btc)

 > engine_eth = Engine.new(market_eth)



 > buyer = Buyer.new({EURO: 45000, BTC: 0, ETH: 0})

 > seller = Seller.new({EURO: 0, BTC: 3, ETH: 3})

 > account_manager = AccountManager.new

 > account_manager.add(buyer)

 > account_manager.add(seller)

 > order_a = Order.new({ amount: 1.000, price: 27000, side: 'bid' })

 > order_b = Order.new({ amount: 1.000, price: 27000, side: 'ask' })

 > engine_btc.submit(order_a)
=> 1
 > engine_btc.submit(order_b)
=> 2
 > engine_btc.match
=> 1
 > order_3 = Order.new({ amount: 1.000, price: 17000, side: 'bid' })

 > order_4 = Order.new({ amount: 1.000, price: 17000, side: 'ask' })

 > engine_eth.submit(order_3)
=> 1

 > engine_eth.submit(order_4)
=> 2
 > engine_eth.match
=> 0


```
require_relative "main"
market_btc = Market.new({base: "BTC", quote: "EURO"})
market_eth = Market.new({base: "ETH", quote: "EURO"})
engine_btc = Engine.new(market_btc)
engine_eth = Engine.new(market_eth)
buyer = Buyer.new({EURO: 45000, BTC: 0, ETH: 0})
seller = Seller.new({EURO: 0, BTC: 3, ETH: 3})
account_manager = AccountManager.new
account_manager.add(buyer)
account_manager.add(seller)
order_a = Order.new({ amount: 1.000, price: 27000, side: 'bid' })
order_b = Order.new({ amount: 1.000, price: 27000, side: 'ask' })
engine_btc.submit(order_a)
engine_btc.submit(order_b)
engine_btc.match
order_3 = Order.new({ amount: 1.000, price: 17000, side: 'bid' })
order_4 = Order.new({ amount: 1.000, price: 17000, side: 'ask' })
engine_eth.submit(order_3)
engine_eth.submit(order_4)
engine_eth.match