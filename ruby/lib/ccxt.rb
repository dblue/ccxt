require 'ccxt/version'
require 'ccxt/base/exchange'

module Ccxt
  @exchanges = [
    'gdax',
    'binance',
    'bitfinex',
    'bitmex',
    'bittrex',
    'coinbase',
    'coinbaseprime',
    'coinbasepro',
    'coss',
    'exx',
    'gemini',
    'hitbtc',
    'kraken',
    'kucoin',
    'livecoin',
    'okcoinusd',
    'okex',
    'poloniex',
    'zb'
  ].each do |exchange|
    require "ccxt/#{exchange}"

    define_singleton_method exchange do |*args|
      self[exchange].new *args
    end
  end.freeze

  def self.exchanges
    @exchanges
  end

  def self.[](key)
    if Ccxt.exchanges.include? key
      class_name = key.split('_').collect(&:capitalize).join
      return const_get class_name
    else
      return nil
    end
  end
end
