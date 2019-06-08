# -*- coding: utf-8 -*-
# frozen_string_literal: true

# PLEASE DO NOT EDIT THIS FILE, IT IS GENERATED AND WILL BE OVERWRITTEN:
# https://github.com/ccxt/ccxt/blob/master/CONTRIBUTING.md#how-to-contribute-code

module Ccxt
  class Paymium < Exchange
    def describe
      return self.deep_extend(super, {
        'id' => 'paymium',
        'name' => 'Paymium',
        'countries' => ['FR', 'EU'],
        'rateLimit' => 2000,
        'version' => 'v1',
        'has' => {
          'CORS' => true
        },
        'urls' => {
          'logo' => 'https://user-images.githubusercontent.com/1294454/27790564-a945a9d4-5ff9-11e7-9d2d-b635763f2f24.jpg',
          'api' => 'https://paymium.com/api',
          'www' => 'https://www.paymium.com',
          'doc' => [
            'https://github.com/Paymium/api-documentation',
            'https://www.paymium.com/page/developers'
          ]
        },
        'api' => {
          'public' => {
            'get' => [
              'countries',
              'data/{id}/ticker',
              'data/{id}/trades',
              'data/{id}/depth',
              'bitcoin_charts/{id}/trades',
              'bitcoin_charts/{id}/depth'
            ]
          },
          'private' => {
            'get' => [
              'merchant/get_payment/{UUID}',
              'user',
              'user/addresses',
              'user/addresses/{btc_address}',
              'user/orders',
              'user/orders/{UUID}',
              'user/price_alerts'
            ],
            'post' => [
              'user/orders',
              'user/addresses',
              'user/payment_requests',
              'user/price_alerts',
              'merchant/create_payment'
            ],
            'delete' => [
              'user/orders/{UUID}/cancel',
              'user/price_alerts/{id}'
            ]
          }
        },
        'markets' => {
          'BTC/EUR' => { 'id' => 'eur', 'symbol' => 'BTC/EUR', 'base' => 'BTC', 'quote' => 'EUR' }
        },
        'fees' => {
          'trading' => {
            'maker' => 0.0059,
            'taker' => 0.0059
          }
        }
      })
    end

    def fetch_balance(params = {})
      balances = self.privateGetUser
      result = { 'info' => balances }
      currencies = self.currencies.keys
      for i in (0...currencies.length)
        currency = currencies[i]
        lowercase = currency.downcase
        account = self.account
        balance = 'balance_' + lowercase
        locked = 'locked_' + lowercase
        if balances.include?(balance)
          account['free'] = balances[balance]
        end
        if balances.include?(locked)
          account['used'] = balances[locked]
        end
        account['total'] = self.sum(account['free'], account['used'])
        result[currency] = account
      end
      return self.parse_balance(result)
    end

    def fetch_order_book(symbol, limit = nil, params = {})
      orderbook = self.publicGetDataIdDepth(self.shallow_extend({
        'id' => self.market_id(symbol)
      }, params))
      return self.parse_order_book(orderbook, nil, 'bids', 'asks', 'price', 'amount')
    end

    def fetch_ticker(symbol, params = {})
      ticker = self.publicGetDataIdTicker(self.shallow_extend({
        'id' => self.market_id(symbol)
      }, params))
      timestamp = ticker['at'] * 1000
      vwap = self.safe_float(ticker, 'vwap')
      baseVolume = self.safe_float(ticker, 'volume')
      quoteVolume = nil
      if baseVolume != nil && vwap != nil
        quoteVolume = baseVolume * vwap
      end
      last = self.safe_float(ticker, 'price')
      return {
        'symbol' => symbol,
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'high' => self.safe_float(ticker, 'high'),
        'low' => self.safe_float(ticker, 'low'),
        'bid' => self.safe_float(ticker, 'bid'),
        'bidVolume' => nil,
        'ask' => self.safe_float(ticker, 'ask'),
        'askVolume' => nil,
        'vwap' => vwap,
        'open' => self.safe_float(ticker, 'open'),
        'close' => last,
        'last' => last,
        'previousClose' => nil,
        'change' => nil,
        'percentage' => self.safe_float(ticker, 'variation'),
        'average' => nil,
        'baseVolume' => baseVolume,
        'quoteVolume' => quoteVolume,
        'info' => ticker
      }
    end

    def parse_trade(trade, market)
      timestamp = parse_int(trade['created_at_int']) * 1000
      volume = 'traded_' + market['base'].downcase
      return {
        'info' => trade,
        'id' => trade['uuid'],
        'order' => nil,
        'timestamp' => timestamp,
        'datetime' => self.iso8601(timestamp),
        'symbol' => market['symbol'],
        'type' => nil,
        'side' => trade['side'],
        'price' => trade['price'],
        'amount' => trade[volume]
      }
    end

    def fetch_trades(symbol, since = nil, limit = nil, params = {})
      market = self.market(symbol)
      response = self.publicGetDataIdTrades(self.shallow_extend({
        'id' => market['id']
      }, params))
      return self.parse_trades(response, market, since, limit)
    end

    def create_order(symbol, type, side, amount, price = nil, params = {})
      order = {
        'type' => self.capitalize(type) + 'Order',
        'currency' => self.market_id(symbol),
        'direction' => side,
        'amount' => amount
      }
      if type != 'market'
        order['price'] = price
      end
      response = self.privatePostUserOrders(self.shallow_extend(order, params))
      return {
        'info' => response,
        'id' => response['uuid']
      }
    end

    def cancel_order(id, symbol = nil, params = {})
      return self.privateDeleteUserOrdersUUIDCancel(self.shallow_extend({
        'UUID' => id
      }, params))
    end

    def sign(path, api = 'public', method = 'GET', params = {}, headers = nil, body = nil)
      url = self.urls['api'] + '/' + self.version + '/' + self.implode_params(path, params)
      query = self.omit(params, self.extract_params(path))
      if api == 'public'
        if query
          url += '?' + self.urlencode(query)
        end
      else
        self.check_required_credentials
        nonce = self.nonce.to_s
        auth = nonce + url
        if method == 'POST'
          if query
            body = self.json(query)
            auth += body
          end
        end
        headers = {
          'Api-Key' => self.apiKey,
          'Api-Signature' => self.hmac(self.encode(auth), self.encode(self.secret)),
          'Api-Nonce' => nonce,
          'Content-Type' => 'application/json'
        }
      end
      return { 'url' => url, 'method' => method, 'body' => body, 'headers' => headers }
    end

    def request(path, api = 'public', method = 'GET', params = {}, headers = nil, body = nil)
      response = self.fetch2(path, api, method, params, headers, body)
      if response.include?('errors')
        raise(ExchangeError, self.id + ' ' + self.json(response))
      end
      return response
    end
  end
end
