# -*- coding: utf-8 -*-
# frozen_string_literal: true

# PLEASE DO NOT EDIT THIS FILE, IT IS GENERATED AND WILL BE OVERWRITTEN:
# https://github.com/ccxt/ccxt/blob/master/CONTRIBUTING.md#how-to-contribute-code

module Ccxt
  class Negociecoins < Exchange
    def describe
      return self.deep_extend(super, {
        'id' => 'negociecoins',
        'name' => 'NegocieCoins',
        'countries' => ['BR'],
        'rateLimit' => 1000,
        'version' => 'v3',
        'has' => {
          'createMarketOrder' => false,
          'fetchOrder' => true,
          'fetchOrders' => true,
          'fetchOpenOrders' => true,
          'fetchClosedOrders' => true
        },
        'urls' => {
          'logo' => 'https://user-images.githubusercontent.com/1294454/38008571-25a6246e-3258-11e8-969b-aeb691049245.jpg',
          'api' => {
            'public' => 'https://broker.negociecoins.com.br/api/v3',
            'private' => 'https://broker.negociecoins.com.br/tradeapi/v1'
          },
          'www' => 'https://www.negociecoins.com.br',
          'doc' => [
            'https://www.negociecoins.com.br/documentacao-tradeapi',
            'https://www.negociecoins.com.br/documentacao-api'
          ],
          'fees' => 'https://www.negociecoins.com.br/comissoes'
        },
        'api' => {
          'public' => {
            'get' => [
              '{PAR}/ticker',
              '{PAR}/orderbook',
              '{PAR}/trades',
              '{PAR}/trades/{timestamp_inicial}',
              '{PAR}/trades/{timestamp_inicial}/{timestamp_final}'
            ]
          },
          'private' => {
            'get' => [
              'user/balance',
              'user/order/{orderId}'
            ],
            'post' => [
              'user/order',
              'user/orders'
            ],
            'delete' => [
              'user/order/{orderId}'
            ]
          }
        },
        'markets' => {
          'B2X/BRL' => { 'id' => 'b2xbrl', 'symbol' => 'B2X/BRL', 'base' => 'B2X', 'quote' => 'BRL' },
          'BCH/BRL' => { 'id' => 'bchbrl', 'symbol' => 'BCH/BRL', 'base' => 'BCH', 'quote' => 'BRL' },
          'BTC/BRL' => { 'id' => 'btcbrl', 'symbol' => 'BTC/BRL', 'base' => 'BTC', 'quote' => 'BRL' },
          'BTG/BRL' => { 'id' => 'btgbrl', 'symbol' => 'BTG/BRL', 'base' => 'BTG', 'quote' => 'BRL' },
          'DASH/BRL' => { 'id' => 'dashbrl', 'symbol' => 'DASH/BRL', 'base' => 'DASH', 'quote' => 'BRL' },
          'LTC/BRL' => { 'id' => 'ltcbrl', 'symbol' => 'LTC/BRL', 'base' => 'LTC', 'quote' => 'BRL' }
        },
        'fees' => {
          'trading' => {
            'maker' => 0.003,
            'taker' => 0.004
          },
          'funding' => {
            'withdraw' => {
              'BTC' => 0.001,
              'BCH' => 0.00003,
              'BTG' => 0.00009,
              'LTC' => 0.005
            }
          }
        },
        'limits' => {
          'amount' => {
            'min' => 0.001,
            'max' => nil
          }
        },
        'precision' => {
          'amount' => 8,
          'price' => 8
        }
      })
    end

    def parse_ticker(ticker, market = nil)
      timestamp = ticker['date'] * 1000
      symbol = (market != nil) ? market['symbol'] : nil
      last = self.safe_float(ticker, 'last')
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
        'open' => nil,
        'close' => last,
        'last' => last,
        'previousClose' => nil,
        'change' => nil,
        'percentage' => nil,
        'average' => nil,
        'baseVolume' => self.safe_float(ticker, 'vol'),
        'quoteVolume' => nil,
        'info' => ticker
      }
    end

    def fetch_ticker(symbol, params = {})
      self.load_markets
      market = self.market(symbol)
      ticker = self.publicGetPARTicker(self.shallow_extend({
        'PAR' => market['id']
      }, params))
      return self.parse_ticker(ticker, market)
    end

    def fetch_order_book(symbol, limit = nil, params = {})
      self.load_markets
      orderbook = self.publicGetPAROrderbook(self.shallow_extend({
        'PAR' => self.market_id(symbol)
      }, params))
      return self.parse_order_book(orderbook, nil, 'bid', 'ask', 'price', 'quantity')
    end

    def parse_trade(trade, market = nil)
      timestamp = trade['date'] * 1000
      price = self.safe_float(trade, 'price')
      amount = self.safe_float(trade, 'amount')
      symbol = market['symbol']
      cost = parse_float(self.cost_to_precision(symbol, price * amount))
      return {
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'symbol' => symbol,
        'id' => self.safe_string(trade, 'tid'),
        'order' => nil,
        'type' => 'limit',
        'side' => trade['type'].downcase,
        'price' => price,
        'amount' => amount,
        'cost' => cost,
        'fee' => nil,
        'info' => trade
      }
    end

    def fetch_trades(symbol, since = nil, limit = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      if since.nil?
        since = 0
      end
      request = {
        'PAR' => market['id'],
        'timestamp_inicial' => parse_int(since / 1000)
      }
      trades = self.publicGetPARTradesTimestampInicial(self.shallow_extend(request, params))
      return self.parse_trades(trades, market, since, limit)
    end

    def fetch_balance(params = {})
      self.load_markets
      response = self.privateGetUserBalance(params)
      #
      #     {
      #         "coins" => [
      #             {"name":"BRL","available":0.0,"openOrders":0.0,"withdraw":0.0,"total":0.0},
      #             {"name":"BTC","available":0.0,"openOrders":0.0,"withdraw":0.0,"total":0.0},
      #         ],
      #     }
      #
      result = { 'info' => response }
      balances = self.safe_value(response, 'coins')
      for i in (0...balances.length)
        balance = balances[i]
        currencyId = self.safe_string(balance, 'name')
        code = self.common_currency_code(currencyId)
        openOrders = self.safe_float(balance, 'openOrders')
        withdraw = self.safe_float(balance, 'withdraw')
        account = {
          'free' => self.safe_float(balance, 'total'),
          'used' => self.sum(openOrders, withdraw),
          'total' => self.safe_float(balance, 'available')
        }
        account['used'] = account['total'] - account['free']
        result[code] = account
      end
      return self.parse_balance(result)
    end

    def parse_order(order, market = nil)
      symbol = nil
      if market.nil?
        market = self.safe_value(self.marketsById, order['pair'])
        if market
          symbol = market['symbol']
        end
      end
      timestamp = self.parse8601(order['created'])
      price = self.safe_float(order, 'price')
      amount = self.safe_float(order, 'quantity')
      cost = self.safe_float(order, 'total')
      remaining = self.safe_float(order, 'pending_quantity')
      filled = self.safe_float(order, 'executed_quantity')
      status = order['status']
      # cancelled, filled, partially filled, pending, rejected
      if status == 'filled'
        status = 'closed'
      elsif status == 'cancelled'
        status = 'canceled'
      else
        status = 'open'
      end
      trades = nil
      # if order['operations']
      #     trades = self.parse_trades(order['operations'])
      return {
        'id' => order['id'].to_s,
        'datetime' => self.iso8601(timestamp),
        'timestamp' => timestamp,
        'lastTradeTimestamp' => nil,
        'status' => status,
        'symbol' => symbol,
        'type' => 'limit',
        'side' => order['type'],
        'price' => price,
        'cost' => cost,
        'amount' => amount,
        'filled' => filled,
        'remaining' => remaining,
        'trades' => trades,
        'fee' => {
          'currency' => market['quote'],
          'cost' => self.safe_float(order, 'fee')
        },
        'info' => order
      }
    end

    def create_order(symbol, type, side, amount, price = nil, params = {})
      self.load_markets
      market = self.market(symbol)
      response = self.privatePostUserOrder(self.shallow_extend({
        'pair' => market['id'],
        'price' => self.price_to_precision(symbol, price),
        'volume' => self.amount_to_precision(symbol, amount),
        'type' => side
      }, params))
      order = self.parse_order(response[0], market)
      id = order['id']
      self.orders[id] = order
      return order
    end

    def cancel_order(id, symbol = nil, params = {})
      self.load_markets
      market = self.markets[symbol]
      response = self.privateDeleteUserOrderOrderId(self.shallow_extend({
        'orderId' => id
      }, params))
      return self.parse_order(response[0], market)
    end

    def fetch_order(id, symbol = nil, params = {})
      self.load_markets
      order = self.privateGetUserOrderOrderId(self.shallow_extend({
        'orderId' => id
      }, params))
      return self.parse_order(order[0])
    end

    def fetch_orders(symbol = nil, since = nil, limit = nil, params = {})
      self.load_markets
      if symbol.nil?
        raise(ArgumentsRequired, self.id + ' fetchOrders requires a symbol argument')
      end
      market = self.market(symbol)
      request = {
        'pair' => market['id'],
        # type => buy, sell
        # status => cancelled, filled, partially filled, pending, rejected
        # startId
        # endId
        # startDate yyyy-MM-dd
        # endDate => yyyy-MM-dd
      }
      if since != nil
        request['startDate'] = self.ymd(since)
      end
      if limit != nil
        request['pageSize'] = limit
      end
      orders = self.privatePostUserOrders(self.shallow_extend(request, params))
      return self.parse_orders(orders, market)
    end

    def fetch_open_orders(symbol = nil, since = nil, limit = nil, params = {})
      return self.fetch_orders(symbol, since, limit, self.shallow_extend({
        'status' => 'pending'
      }, params))
    end

    def fetch_closed_orders(symbol = nil, since = nil, limit = nil, params = {})
      return self.fetch_orders(symbol, since, limit, self.shallow_extend({
        'status' => 'filled'
      }, params))
    end

    def nonce
      return self.milliseconds
    end

    def sign(path, api = 'public', method = 'GET', params = {}, headers = nil, body = nil)
      url = self.urls['api'][api] + '/' + self.implode_params(path, params)
      query = self.omit(params, self.extract_params(path))
      queryString = self.urlencode(query)
      if api == 'public'
        if queryString.length
          url += '?' + queryString
        end
      else
        self.check_required_credentials
        timestamp = self.seconds.to_s
        nonce = self.nonce.to_s
        content = ''
        if queryString.length
          body = self.json(query)
          content = self.hash(self.encode(body), 'md5', 'base64')
        else
          body = ''
        end
        uri = self.encode_uri_component(url).downcase
        payload = ''.join([self.apiKey, method, uri, timestamp, nonce, content])
        secret = Base64.decode64(self.secret)
        signature = self.hmac(self.encode(payload), secret, 'sha256', 'base64')
        signature = self.binary_to_string(signature)
        auth = ':'.join([self.apiKey, signature, nonce, timestamp])
        headers = {
          'Authorization' => 'amx ' + auth
        }
        if method == 'POST'
          headers['Content-Type'] = 'application/json charset=UTF-8'
          headers['Content-Length'] = body.length
        elsif queryString.length
          url += '?' + queryString
          body = nil
        end
      end
      return { 'url' => url, 'method' => method, 'body' => body, 'headers' => headers }
    end
  end
end
