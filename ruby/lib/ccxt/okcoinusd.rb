# -*- coding: utf-8 -*-
# frozen_string_literal: true

# PLEASE DO NOT EDIT THIS FILE, IT IS GENERATED AND WILL BE OVERWRITTEN:
# https://github.com/ccxt/ccxt/blob/master/CONTRIBUTING.md#how-to-contribute-code

module Ccxt
  class Okcoinusd < Exchange
    def describe
      return self.deep_extend(super, {
        'id' => 'okcoinusd',
        'name' => 'OKCoin USD',
        'countries' => ['CN', 'US'],
        'version' => 'v1',
        'rateLimit' => 1000, # up to 3000 requests per 5 minutes ≈ 600 requests per minute ≈ 10 requests per second ≈ 100 ms
        'has' => {
          'CORS' => false,
          'fetchOHLCV' => true,
          'fetchOrder' => true,
          'fetchOrders' => false,
          'fetchOpenOrders' => true,
          'fetchClosedOrders' => true,
          'withdraw' => true,
          'futures' => false
        },
        'extension' => '.do', # appended to endpoint URL
        'timeframes' => {
          '1m' => '1min',
          '3m' => '3min',
          '5m' => '5min',
          '15m' => '15min',
          '30m' => '30min',
          '1h' => '1hour',
          '2h' => '2hour',
          '4h' => '4hour',
          '6h' => '6hour',
          '12h' => '12hour',
          '1d' => '1day',
          '3d' => '3day',
          '1w' => '1week'
        },
        'api' => {
          'web' => {
            'get' => [
              'futures/pc/market/marketOverview', # todo => merge in fetchMarkets
              'spot/markets/index-tickers', # todo => add fetchTickers
              'spot/markets/currencies',
              'spot/markets/products',
              'spot/markets/tickers',
              'spot/user-level'
            ]
          },
          'public' => {
            'get' => [
              'depth',
              'exchange_rate',
              'future_depth',
              'future_estimated_price',
              'future_hold_amount',
              'future_index',
              'future_kline',
              'future_price_limit',
              'future_ticker',
              'future_trades',
              'kline',
              'otcs',
              'ticker',
              'tickers', # todo => add fetchTickers
              'trades'
            ]
          },
          'private' => {
            'post' => [
              'account_records',
              'batch_trade',
              'borrow_money',
              'borrow_order_info',
              'borrows_info',
              'cancel_borrow',
              'cancel_order',
              'cancel_otc_order',
              'cancel_withdraw',
              'funds_transfer',
              'future_batch_trade',
              'future_cancel',
              'future_devolve',
              'future_explosive',
              'future_order_info',
              'future_orders_info',
              'future_position',
              'future_position_4fix',
              'future_trade',
              'future_trades_history',
              'future_userinfo',
              'future_userinfo_4fix',
              'lend_depth',
              'order_fee',
              'order_history',
              'order_info',
              'orders_info',
              'otc_order_history',
              'otc_order_info',
              'repayment',
              'submit_otc_order',
              'trade',
              'trade_history',
              'trade_otc_order',
              'wallet_info',
              'withdraw',
              'withdraw_info',
              'unrepayments_info',
              'userinfo'
            ]
          }
        },
        'urls' => {
          'logo' => 'https://user-images.githubusercontent.com/1294454/27766791-89ffb502-5ee5-11e7-8a5b-c5950b68ac65.jpg',
          'api' => {
            'web' => 'https://www.okcoin.com/v2',
            'public' => 'https://www.okcoin.com/api',
            'private' => 'https://www.okcoin.com'
          },
          'www' => 'https://www.okcoin.com',
          'doc' => [
            'https://www.okcoin.com/docs/en/',
            'https://www.npmjs.com/package/okcoin.com'
          ]
        },
        'fees' => {
          'trading' => {
            'taker' => 0.002,
            'maker' => 0.002
          }
        },
        'exceptions' => {
          # see https://github.com/okcoin-okex/API-docs-OKEx.com/blob/master/API-For-Spot-EN/Error%20Code%20For%20Spot.md
          '10000' => ExchangeError, # "Required field, can not be null"
          '10001' => DDoSProtection, # "Request frequency too high to exceed the limit allowed"
          '10005' => AuthenticationError, # "'SecretKey' does not exist"
          '10006' => AuthenticationError, # "'Api_key' does not exist"
          '10007' => AuthenticationError, # "Signature does not match"
          '1002' => InsufficientFunds, # "The transaction amount exceed the balance"
          '1003' => InvalidOrder, # "The transaction amount is less than the minimum requirement"
          '1004' => InvalidOrder, # "The transaction amount is less than 0"
          '1013' => InvalidOrder, # no contract type(PR-1101)
          '1027' => InvalidOrder, # createLimitBuyOrder(symbol, 0, 0) => Incorrect parameter may exceeded limits
          '1050' => InvalidOrder, # returned when trying to cancel an order that was filled or canceled previously
          '1217' => InvalidOrder, # "Order was sent at ±5% of the current market price. Please resend"
          '10014' => InvalidOrder, # "Order price must be between 0 and 1,000,000"
          '1009' => OrderNotFound, # for spot markets, cancelling closed order
          '1019' => OrderNotFound, # order closed?("Undo order failed")
          '1051' => OrderNotFound, # for spot markets, cancelling "just closed" order
          '10009' => OrderNotFound, # for spot markets, "Order does not exist"
          '20015' => OrderNotFound, # for future markets
          '10008' => ExchangeError, # Illegal URL parameter
          # todo => sort out below
          # 10000 Required parameter is empty
          # 10001 Request frequency too high to exceed the limit allowed
          # 10002 Authentication failure
          # 10002 System error
          # 10003 This connection has requested other user data
          # 10004 Request failed
          # 10005 api_key or sign is invalid, 'SecretKey' does not exist
          # 10006 'Api_key' does not exist
          # 10007 Signature does not match
          # 10008 Illegal parameter, Parameter erorr
          # 10009 Order does not exist
          # 10010 Insufficient funds
          # 10011 Amount too low
          # 10012 Only btc_usd ltc_usd supported
          # 10013 Only support https request
          # 10014 Order price must be between 0 and 1,000,000
          # 10015 Order price differs from current market price too much / Channel subscription temporally not available
          # 10016 Insufficient coins balance
          # 10017 API authorization error / WebSocket authorization error
          # 10018 borrow amount less than lower limit [usd:100,btc:0.1,ltc:1]
          # 10019 loan agreement not checked
          # 1002 The transaction amount exceed the balance
          # 10020 rate cannot exceed 1%
          # 10021 rate cannot less than 0.01%
          # 10023 fail to get latest ticker
          # 10024 balance not sufficient
          # 10025 quota is full, cannot borrow temporarily
          # 10026 Loan(including reserved loan) and margin cannot be withdrawn
          # 10027 Cannot withdraw within 24 hrs of authentication information modification
          # 10028 Withdrawal amount exceeds daily limit
          # 10029 Account has unpaid loan, please cancel/pay off the loan before withdraw
          # 1003 The transaction amount is less than the minimum requirement
          # 10031 Deposits can only be withdrawn after 6 confirmations
          # 10032 Please enabled phone/google authenticator
          # 10033 Fee higher than maximum network transaction fee
          # 10034 Fee lower than minimum network transaction fee
          # 10035 Insufficient BTC/LTC
          # 10036 Withdrawal amount too low
          # 10037 Trade password not set
          # 1004 The transaction amount is less than 0
          # 10040 Withdrawal cancellation fails
          # 10041 Withdrawal address not exsit or approved
          # 10042 Admin password error
          # 10043 Account equity error, withdrawal failure
          # 10044 fail to cancel borrowing order
          # 10047 self function is disabled for sub-account
          # 10048 withdrawal information does not exist
          # 10049 User can not have more than 50 unfilled small orders(amount<0.15BTC)
          # 10050 can't cancel more than once
          # 10051 order completed transaction
          # 10052 not allowed to withdraw
          # 10064 after a USD deposit, that portion of assets will not be withdrawable for the next 48 hours
          # 1007 No trading market information
          # 1008 No latest market information
          # 1009 No order
          # 1010 Different user of the cancelled order and the original order
          # 10100 User account frozen
          # 10101 order type is wrong
          # 10102 incorrect ID
          # 10103 the private otc order's key incorrect
          # 10106 API key domain not matched
          # 1011 No documented user
          # 1013 No order type
          # 1014 No login
          # 1015 No market depth information
          # 1017 Date error
          # 1018 Order failed
          # 1019 Undo order failed
          # 10216 Non-available API / non-public API
          # 1024 Currency does not exist
          # 1025 No chart type
          # 1026 No base currency quantity
          # 1027 Incorrect parameter may exceeded limits
          # 1028 Reserved decimal failed
          # 1029 Preparing
          # 1030 Account has margin and futures, transactions can not be processed
          # 1031 Insufficient Transferring Balance
          # 1032 Transferring Not Allowed
          # 1035 Password incorrect
          # 1036 Google Verification code Invalid
          # 1037 Google Verification code incorrect
          # 1038 Google Verification replicated
          # 1039 Message Verification Input exceed the limit
          # 1040 Message Verification invalid
          # 1041 Message Verification incorrect
          # 1042 Wrong Google Verification Input exceed the limit
          # 1043 Login password cannot be same as the trading password
          # 1044 Old password incorrect
          # 1045 2nd Verification Needed
          # 1046 Please input old password
          # 1048 Account Blocked
          # 1050 Orders have been withdrawn or withdrawn
          # 1051 Order completed
          # 1201 Account Deleted at 00 => 00
          # 1202 Account Not Exist
          # 1203 Insufficient Balance
          # 1204 Invalid currency
          # 1205 Invalid Account
          # 1206 Cash Withdrawal Blocked
          # 1207 Transfer Not Support
          # 1208 No designated account
          # 1209 Invalid api
          # 1216 Market order temporarily suspended. Please send limit order
          # 1217 Order was sent at ±5% of the current market price. Please resend
          # 1218 Place order failed. Please try again later
          # 20001 User does not exist
          # 20002 Account frozen
          # 20003 Account frozen due to forced liquidation
          # 20004 Contract account frozen
          # 20005 User contract account does not exist
          # 20006 Required field missing
          # 20007 Illegal parameter
          # 20008 Contract account balance is too low
          # 20009 Contract status error
          # 20010 Risk rate ratio does not exist
          # 20011 Risk rate lower than 90%/80% before opening BTC position with 10x/20x leverage. or risk rate lower than 80%/60% before opening LTC position with 10x/20x leverage
          # 20012 Risk rate lower than 90%/80% after opening BTC position with 10x/20x leverage. or risk rate lower than 80%/60% after opening LTC position with 10x/20x leverage
          # 20013 Temporally no counter party price
          # 20014 System error
          # 20015 Order does not exist
          # 20016 Close amount bigger than your open positions, liquidation quantity bigger than holding
          # 20017 Not authorized/illegal operation/illegal order ID
          # 20018 Order price cannot be more than 103-105% or less than 95-97% of the previous minute price
          # 20019 IP restricted from accessing the resource
          # 20020 Secret key does not exist
          # 20021 Index information does not exist
          # 20022 Wrong API interface(Cross margin mode shall call cross margin API, fixed margin mode shall call fixed margin API)
          # 20023 Account in fixed-margin mode
          # 20024 Signature does not match
          # 20025 Leverage rate error
          # 20026 API Permission Error
          # 20027 no transaction record
          # 20028 no such contract
          # 20029 Amount is large than available funds
          # 20030 Account still has debts
          # 20038 Due to regulation, self function is not availavle in the country/region your currently reside in.
          # 20049 Request frequency too high
          # 20100 request time out
          # 20101 the format of data is error
          # 20102 invalid login
          # 20103 event type error
          # 20104 subscription type error
          # 20107 JSON format error
          # 20115 The quote is not match
          # 20116 Param not match
          # 21020 Contracts are being delivered, orders cannot be placed
          # 21021 Contracts are being settled, contracts cannot be placed
        },
        'options' => {
          'marketBuyPrice' => false,
          'defaultContractType' => 'this_week', # next_week, quarter
          'warnOnFetchOHLCVLimitArgument' => true,
          'fiats' => ['USD', 'CNY'],
          'futures' => {
            'BCH' => true,
            'BTC' => true,
            'BTG' => true,
            'EOS' => true,
            'ETC' => true,
            'ETH' => true,
            'LTC' => true,
            'NEO' => true,
            'QTUM' => true,
            'USDT' => true,
            'XRP' => true
          }
        }
      })
    end

    def fetch_markets(params = {})
      response = self.webGetSpotMarketsProducts
      markets = response['data']
      result = []
      for i in (0...markets.length)
        id = markets[i]['symbol']
        baseId, quoteId = id.split('_')
        baseIdUppercase = baseId.upcase
        quoteIdUppercase = quoteId.upcase
        base = self.common_currency_code(baseIdUppercase)
        quote = self.common_currency_code(quoteIdUppercase)
        symbol = base + '/' + quote
        precision = {
          'amount' => markets[i]['maxSizeDigit'],
          'price' => markets[i]['maxPriceDigit']
        }
        minAmount = markets[i]['minTradeSize']
        minPrice = 10**-precision['price']
        active = (markets[i]['online'] != 0)
        baseNumericId = markets[i]['baseCurrency']
        quoteNumericId = markets[i]['quoteCurrency']
        market = shallow_extend(self.fees['trading'], {
          'id' => id,
          'symbol' => symbol,
          'base' => base,
          'quote' => quote,
          'baseId' => baseId,
          'quoteId' => quoteId,
          'baseNumericId' => baseNumericId,
          'quoteNumericId' => quoteNumericId,
          'info' => markets[i],
          'type' => 'spot',
          'spot' => true,
          'future' => false,
          'active' => active,
          'precision' => precision,
          'limits' => {
            'amount' => {
              'min' => minAmount,
              'max' => nil
            },
            'price' => {
              'min' => minPrice,
              'max' => nil
            },
            'cost' => {
              'min' => minAmount * minPrice,
              'max' => nil
            }
          }
        })
        result.push(market)
        if (self.has['futures']) && (self.options['futures'].include?(market['base']))
          fiats = self.options['fiats']
          for j in (0...fiats.length)
            fiat = fiats[j]
            lowercaseFiat = fiat.downcase
            result.push(shallow_extend(market, {
              'quote' => fiat,
              'symbol' => market['base'] + '/' + fiat,
              'id' => market['base'].downcase + '_' + lowercaseFiat,
              'quoteId' => lowercaseFiat,
              'type' => 'future',
              'spot' => false,
              'future' => true
            }))
          end
        end
      end
      return result
    end

    def fetch_order_book(symbol, limit = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      method = 'publicGet'
      request = {
        'symbol' => market['id']
      }
      if limit != nil
        request['size'] = limit
      end
      if market['future']
        method += 'Future'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      end
      method += 'Depth'
      orderbook = self.send_wrapper(method, shallow_extend(request, params))
      return self.parse_order_book(orderbook)
    end

    def parse_ticker(ticker, market = nil)
      #
      #     {              buy =>   "48.777300",
      #                 change =>   "-1.244500",
      #       changePercentage =>   "-2.47%",
      #                  close =>   "49.064000",
      #            createdDate =>    1531704852254,
      #             currencyId =>    527,
      #                dayHigh =>   "51.012500",
      #                 dayLow =>   "48.124200",
      #                   high =>   "51.012500",
      #                inflows =>   "0",
      #                   last =>   "49.064000",
      #                    low =>   "48.124200",
      #             marketFrom =>    627,
      #                   name => {  },
      #                   open =>   "50.308500",
      #               outflows =>   "0",
      #              productId =>    527,
      #                   sell =>   "49.064000",
      #                 symbol =>   "zec_okb",
      #                 volume =>   "1049.092535"   }
      #
      timestamp = self.safe_integer_2(ticker, 'timestamp', 'createdDate')
      symbol = nil
      if market.nil?
        if ticker.include?('symbol')
          marketId = ticker['symbol']
          if self.markets_by_id.include?(marketId)
            market = self.markets_by_id[marketId]
          else
            baseId, quoteId = ticker['symbol'].split('_')
            base = baseId.upcase
            quote = quoteId.upcase
            base = self.common_currency_code(base)
            quote = self.common_currency_code(quote)
            symbol = base + '/' + quote
          end
        end
      end
      if market != nil
        symbol = market['symbol']
      end
      last = self.safe_float(ticker, 'last')
      open = self.safe_float(ticker, 'open')
      change = self.safe_float(ticker, 'change')
      percentage = self.safe_float(ticker, 'changePercentage')
      return {
        'symbol' => symbol,
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'high' => self.safe_float(ticker, 'high'),
        'low' => self.safe_float(ticker, 'low'),
        'bid' => self.safe_float(ticker, 'buy'),
        'bidVolume' => nil,
        'ask' => self.safe_float(ticker, 'sell'),
        'askVolume' => nil,
        'vwap' => nil,
        'open' => open,
        'close' => last,
        'last' => last,
        'previousClose' => nil,
        'change' => change,
        'percentage' => percentage,
        'average' => nil,
        'baseVolume' => self.safe_float_2(ticker, 'vol', 'volume'),
        'quoteVolume' => nil,
        'info' => ticker
      }
    end

    def fetch_ticker(symbol, params = {})
      self.load_markets
      market = self.market(symbol)
      method = 'publicGet'
      request = {
        'symbol' => market['id']
      }
      if market['future']
        method += 'Future'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      end
      method += 'Ticker'
      response = self.send_wrapper(method, shallow_extend(request, params))
      ticker = self.safe_value(response, 'ticker')
      if ticker.nil?
        raise(ExchangeError, self.id + ' fetchTicker returned an empty response => ' + self.json(response))
      end
      timestamp = self.safe_integer(response, 'date')
      if timestamp != nil
        timestamp *= 1000
        ticker = shallow_extend(ticker, { 'timestamp' => timestamp })
      end
      return self.parse_ticker(ticker, market)
    end

    def parse_trade(trade, market = nil)
      symbol = nil
      if market
        symbol = market['symbol']
      end
      return {
        'info' => trade,
        'timestamp' => trade['date_ms'],
        'datetime' => self.iso8601(trade['date_ms']),
        'symbol' => symbol,
        'id' => trade['tid'].to_s,
        'order' => nil,
        'type' => nil,
        'side' => trade['type'],
        'price' => self.safe_float(trade, 'price'),
        'amount' => self.safe_float(trade, 'amount')
      }
    end

    def fetch_trades(symbol, since = nil, limit = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      method = 'publicGet'
      request = {
        'symbol' => market['id']
      }
      if market['future']
        method += 'Future'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      end
      method += 'Trades'
      response = self.send_wrapper(method, shallow_extend(request, params))
      return self.parse_trades(response, market, since, limit)
    end

    def parse_ohlcv(ohlcv, market = nil, timeframe = '1m', since = nil, limit = nil)
      numElements = ohlcv.length
      volumeIndex = (numElements > 6) ? 6 : 5
      return [
        ohlcv[0], # timestamp
        ohlcv[1].to_f, # Open
        ohlcv[2].to_f, # High
        ohlcv[3].to_f, # Low
        ohlcv[4].to_f, # Close
        # ohlcv[5].to_f, # quote volume
        # ohlcv[6].to_f, # base volume
        ohlcv[volumeIndex].to_f, # okex will return base volume in the 7th element for future markets
      ]
    end

    def fetch_ohlcv(symbol, timeframe = '1m', since = nil, limit = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      method = 'publicGet'
      request = {
        'symbol' => market['id'],
        'type' => self.timeframes[timeframe]
      }
      if market['future']
        method += 'Future'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      end
      method += 'Kline'
      if limit != nil
        if self.options['warnOnFetchOHLCVLimitArgument']
          raise(ExchangeError, self.id + ' fetchOHLCV counts "limit" candles from current time backwards, therefore the "limit" argument for ' + self.id + ' is disabled. Set ' + self.id + '.options["warnOnFetchOHLCVLimitArgument"] = false to suppress self warning message.')
        end
        request['size'] = (limit).to_i # max is 1440 candles
      end
      if since != nil
        request['since'] = since
      else
        request['since'] = self.milliseconds - 86400000
      end # last 24 hours
      response = self.send_wrapper(method, shallow_extend(request, params))
      return self.parse_ohlcvs(response, market, timeframe, since, limit)
    end

    def fetch_balance(params = {})
      self.load_markets
      response = self.privatePostUserinfo(params)
      balances = response['info']['funds']
      result = { 'info' => response }
      ids = balances['free'].keys
      usedField = 'freezed'
      # wtf, okex?
      # https://github.com/okcoin-okex/API-docs-OKEx.com/commit/01cf9dd57b1f984a8737ef76a037d4d3795d2ac7
      if balances.include?(!(usedField))
        usedField = 'holds'
      end
      usedKeys = balances[usedField].keys
      ids = self.array_concat(ids, usedKeys)
      for i in (0...ids.length)
        id = ids[i]
        code = id.upcase
        if self.currencies_by_id.include?(id)
          code = self.currencies_by_id[id]['code']
        else
          code = self.common_currency_code(code)
        end
        account = self.account
        account['free'] = self.safe_float(balances['free'], id, 0.0)
        account['used'] = self.safe_float(balances[usedField], id, 0.0)
        account['total'] = self.sum(account['free'], account['used'])
        result[code] = account
      end
      return self.parse_balance(result)
    end

    def create_order(symbol, type, side, amount, price = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      method = 'privatePost'
      order = {
        'symbol' => market['id'],
        'type' => side
      }
      if market['future']
        method += 'Future'
        order = shallow_extend(order, {
          'contract_type' => self.options['defaultContractType'], # self_week, next_week, quarter
          'match_price' => 0, # match best counter party price? 0 or 1, ignores price if 1
          'lever_rate' => 10, # leverage rate value => 10 or 20(10 by default)
          'price' => price,
          'amount' => amount
        })
      else
        if type == 'limit'
          order['price'] = price
          order['amount'] = amount
        else
          order['type'] += '_market'
          if side == 'buy'
            if self.options['marketBuyPrice']
              if price.nil?
                # eslint-disable-next-line quotes
                raise(ExchangeError, self.id + " market buy orders require a price argument(the amount you want to spend or the cost of the order) when self.options['marketBuyPrice'] is true.")
              end
              order['price'] = price
            else
              order['price'] = self.safe_float(params, 'cost')
              if !order['price']
                # eslint-disable-next-line quotes
                raise(ExchangeError, self.id + " market buy orders require an additional cost parameter, cost = price * amount. If you want to pass the cost of the market order(the amount you want to spend) in the price argument(the default " + self.id + " behaviour), set self.options['marketBuyPrice'] = true. It will effectively suppress self warning exception as well.")
              end
            end
          else
            order['amount'] = amount
          end
        end
      end
      params = self.omit(params, 'cost')
      method += 'Trade'
      response = self.send_wrapper(method, shallow_extend(order, params))
      timestamp = self.milliseconds
      return {
        'info' => response,
        'id' => response['order_id'].to_s,
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'lastTradeTimestamp' => nil,
        'status' => nil,
        'symbol' => symbol,
        'type' => type,
        'side' => side,
        'price' => price,
        'amount' => amount,
        'filled' => nil,
        'remaining' => nil,
        'cost' => nil,
        'trades' => nil,
        'fee' => nil
      }
    end

    def cancel_order(id, symbol = nil, params = {})
      if symbol.nil?
        raise(ArgumentsRequired, self.id + ' cancelOrder requires a symbol argument')
      end
      self.load_markets
      market = self.market(symbol)
      request = {
        'symbol' => market['id'],
        'order_id' => id
      }
      method = 'privatePost'
      if market['future']
        method += 'FutureCancel'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      else
        method += 'CancelOrder'
      end
      response = self.send_wrapper(method, shallow_extend(request, params))
      return response
    end

    def parse_order_status(status)
      statuses = {
        '-1' => 'canceled',
        '0' => 'open',
        '1' => 'open',
        '2' => 'closed',
        '3' => 'open',
        '4' => 'canceled'
      }
      return self.safe_value(statuses, status, status)
    end

    def parse_order_side(side)
      if side == 1
        return 'buy'
      end # open long position
      if side == 2
        return 'sell'
      end # open short position
      if side == 3
        return 'sell'
      end # liquidate long position
      if side == 4
        return 'buy'
      end # liquidate short position
      return side
    end

    def parse_order(order, market = nil)
      side = nil
      type = nil
      if order.include?('type')
        if (order['type'] == 'buy') || (order['type'] == 'sell')
          side = order['type']
          type = 'limit'
        elsif order['type'] == 'buy_market'
          side = 'buy'
          type = 'market'
        elsif order['type'] == 'sell_market'
          side = 'sell'
          type = 'market'
        else
          side = self.parse_order_side(order['type'])
          if order.include?(('contract_name')) || (order.include?('lever_rate'))
            type = 'margin'
          end
        end
      end
      status = self.parse_order_status(self.safe_string(order, 'status'))
      symbol = nil
      if market.nil?
        marketId = self.safe_string(order, 'symbol')
        if self.markets_by_id.include?(marketId)
          market = self.markets_by_id[marketId]
        end
      end
      if market
        symbol = market['symbol']
      end
      timestamp = nil
      createDateField = self.get_create_date_field
      if order.include?(createDateField)
        timestamp = order[createDateField]
      end
      amount = self.safe_float(order, 'amount')
      filled = self.safe_float(order, 'deal_amount')
      amount = Math.max(amount, filled)
      remaining = Math.max(0, amount - filled)
      if type == 'market'
        remaining = 0
      end
      average = self.safe_float(order, 'avg_price')
      # https://github.com/ccxt/ccxt/issues/2452
      average = self.safe_float(order, 'price_avg', average)
      cost = average * filled
      result = {
        'info' => order,
        'id' => order['order_id'].to_s,
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'lastTradeTimestamp' => nil,
        'symbol' => symbol,
        'type' => type,
        'side' => side,
        'price' => order['price'],
        'average' => average,
        'cost' => cost,
        'amount' => amount,
        'filled' => filled,
        'remaining' => remaining,
        'status' => status,
        'fee' => nil
      }
      return result
    end

    def get_create_date_field
      # needed for derived exchanges
      # allcoin typo create_data instead of create_date
      return 'create_date'
    end

    def get_orders_field
      # needed for derived exchanges
      # allcoin typo order instead of orders(expected based on their API docs)
      return 'orders'
    end

    def fetch_order(id, symbol = nil, params = {})
      if symbol.nil?
        raise(ExchangeError, self.id + ' fetchOrder requires a symbol parameter')
      end
      self.load_markets
      market = self.market(symbol)
      method = 'privatePost'
      request = {
        'order_id' => id,
        'symbol' => market['id'],
        # 'status' => 0, # 0 for unfilled orders, 1 for filled orders
        # 'current_page' => 1, # current page number
        # 'page_length' => 200, # number of orders returned per page, maximum 200
      }
      if market['future']
        method += 'Future'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
      end
      method += 'OrderInfo'
      response = self.send_wrapper(method, shallow_extend(request, params))
      ordersField = self.get_orders_field
      numOrders = response[ordersField].length
      if numOrders > 0
        return self.parse_order(response[ordersField][0])
      end
      raise(OrderNotFound, self.id + ' order ' + id + ' not found')
    end

    def fetch_orders(symbol = nil, since = nil, limit = nil, params = {})
      if symbol.nil?
        raise(ExchangeError, self.id + ' fetchOrders requires a symbol parameter')
      end
      self.load_markets
      market = self.market(symbol)
      method = 'privatePost'
      request = {
        'symbol' => market['id']
      }
      order_id_in_params = (params.include?('order_id'))
      if market['future']
        method += 'FutureOrdersInfo'
        request['contract_type'] = self.options['defaultContractType'] # self_week, next_week, quarter
        if !order_id_in_params
          raise(ExchangeError, self.id + ' fetchOrders requires order_id param for futures market ' + symbol + '(a string of one or more order ids, comma-separated)')
        end
      else
        status = nil
        if params.include?('type')
          status = params['type']
        elsif params.include?('status')
          status = params['status']
        else
          name = order_id_in_params ? 'type' : 'status'
          raise(ExchangeError, self.id + ' fetchOrders requires ' + name + ' param for spot market ' + symbol + '(0 - for unfilled orders, 1 - for filled/canceled orders)')
        end
        if order_id_in_params
          method += 'OrdersInfo'
          request = shallow_extend(request, {
            'type' => status,
            'order_id' => params['order_id']
          })
        else
          method += 'OrderHistory'
          request = shallow_extend(request, {
            'status' => status,
            'current_page' => 1, # current page number
            'page_length' => 200, # number of orders returned per page, maximum 200
          })
        end
        params = self.omit(params, ['type', 'status'])
      end
      response = self.send_wrapper(method, shallow_extend(request, params))
      ordersField = self.get_orders_field
      return self.parse_orders(response[ordersField], market, since, limit)
    end

    def fetch_open_orders(symbol = nil, since = nil, limit = nil, params = {})
      open = 0 # 0 for unfilled orders, 1 for filled orders
      return self.fetch_orders(symbol, since, limit, shallow_extend({
        'status' => open
      }, params))
    end

    def fetch_closed_orders(symbol = nil, since = nil, limit = nil, params = {})
      closed = 1 # 0 for unfilled orders, 1 for filled orders
      orders = self.fetch_orders(symbol, since, limit, shallow_extend({
        'status' => closed
      }, params))
      return orders
    end

    def withdraw(code, amount, address, tag = nil, params = {})
      self.check_address(address)
      self.load_markets
      currency = self.currency(code)
      # if amount < 0.01
      #     raise(ExchangeError, self.id + ' withdraw requires amount > 0.01')
      # for some reason they require to supply a pair of currencies for withdrawing one currency
      currencyId = currency['id'] + '_usd'
      if tag
        address = address + ':' + tag
      end
      request = {
        'symbol' => currencyId,
        'withdraw_address' => address,
        'withdraw_amount' => amount,
        'target' => 'address', # or 'okcn', 'okcom', 'okex'
      }
      query = params
      if query.include?('chargefee')
        request['chargefee'] = query['chargefee']
        query = self.omit(query, 'chargefee')
      else
        raise(ExchangeError, self.id + ' withdraw requires a `chargefee` parameter')
      end
      if self.password
        request['trade_pwd'] = self.password
      elsif query.include?('password')
        request['trade_pwd'] = query['password']
        query = self.omit(query, 'password')
      elsif query.include?('trade_pwd')
        request['trade_pwd'] = query['trade_pwd']
        query = self.omit(query, 'trade_pwd')
      end
      passwordInRequest = (request.include?('trade_pwd'))
      if !passwordInRequest
        raise(ExchangeError, self.id + ' withdraw requires self.password set on the exchange instance or a password / trade_pwd parameter')
      end
      response = self.privatePostWithdraw(shallow_extend(request, query))
      return {
        'info' => response,
        'id' => self.safe_string(response, 'withdraw_id')
      }
    end

    def sign(path, api = 'public', method = 'GET', params = {}, headers = nil, body = nil)
      url = '/'
      if api != 'web'
        url += self.version + '/'
      end
      url += path
      if api != 'web'
        url += self.extension
      end
      if api == 'private'
        self.check_required_credentials
        query = self.keysort(shallow_extend({
          'api_key' => self.apiKey
        }, params))
        # secret key must be at the end of query
        queryString = self.rawencode(query) + '&secret_key=' + self.secret
        query['sign'] = self.hash(self.encode(queryString)).upcase
        body = self.urlencode(query)
        headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      else
        if params
          url += '?' + self.urlencode(params)
        end
      end
      url = self.urls['api'][api] + url
      return { 'url' => url, 'method' => method, 'body' => body, 'headers' => headers }
    end

    def handle_errors(code, reason, url, method, headers, body, response)
      if body.length < 2
        return
      end # fallback to default error handler
      if body[0] == '{'
        if response.include?('error_code')
          error = self.safe_string(response, 'error_code')
          message = self.id + ' ' + self.json(response)
          if self.exceptions.include?(error)
            # ExceptionClass = self.exceptions[error]
            # raise(ExceptionClass, message)
            raise(self.exceptions[error], message)
          else
            raise(ExchangeError, message)
          end
        end
        if response.include?('result')
          if !response['result']
            raise(ExchangeError, self.id + ' ' + self.json(response))
          end
        end
      end
    end
  end
end
