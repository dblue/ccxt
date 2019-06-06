# test async

require 'async'
require 'async/await'
require 'ccxt'

def style(s, style)
  return style + s.to_s + "\033[0m"
end

def green(s)
  return style(s, "\033[92m")
end

def blue(s)
  return style(s, "\033[94m")
end

def yellow(s)
  return style(s, "\033[93m")
end

def red(s)
  return style(s, "\033[91m")
end

def pink(s)
  return style(s, "\033[95m")
end

def bold(s)
  return style(s, "\033[1m")
end

def underline(s)
  return style(s, "\033[4m")
end

def print_supported_exchanges
  puts 'Supported exchanges: ' + green(Ccxt.exchanges.join(', '))
end

def dump(*args)
  puts args.collect{ |arg| arg.to_s }.join(' ')
end

class TestAsync
  include Async::Await

  def initialize
    @exchanges = {}
  end

  async def load_exchange(exchange)
    await { exchange.load_markets() }
  end

  # main loop

  # # prefer local testing keys to global keys
  # keys_folder = os.path.dirname(root)
  # keys_global = os.path.join(keys_folder, 'keys.json')
  # keys_local = os.path.join(keys_folder, 'keys.local.json')
  # keys_file = keys_local if os.path.exists(keys_local) else keys_global

  async def test_ticker(exchange, symbol)
    if exchange.has['fetchTicker']
      delay = exchange.rateLimit / 1000
      Async do |task|
        task.sleep(delay)
        ticker = await {exchange.fetch_ticker(symbol)}
        dump(
            green(exchange.id),
            green(symbol),
            'ticker',
            ticker['datetime'],
            'high: ' + ticker['high'].to_s,
            'low: ' + ticker['low'].to_s,
            'bid: ' + ticker['bid'].to_s,
            'ask: ' + ticker['ask'].to_s,
            'volume: ' + ticker['quoteVolume'].to_s
            )
      end
    else
      dump(green(exchange.id), 'fetch_ticker not supported')
    end
  end

  async def test_symbol( exchange, symbol )
    dump(green("SYMBOL: " + symbol))
  
    await {test_ticker(exchange, symbol)}

    # if exchange.id == 'coinmaketcap'
    #   response = await {exchange.fetchGlobal}
    #   puts response
    # else
    #   await {test_order_book(exchange, symbol)}
    #   await {test_trades(exchange, symbol)}
    # end
    # await {test_tickers(exchange, symbol)}
    # await {test_ohlcv(exchange, symbol)}
  end

  def test_exchange( exchange )
    dump(green("EXCHANGE: " + exchange.id))
    keys = exchange.markets.keys

    # ..........................................................................
    # public API

    symbol = keys.first
    symbols = [
        'BTC/USD',
        'BTC/USDT',
        'BTC/CNY',
        'BTC/EUR',
        'BTC/ETH',
        'ETH/BTC',
        'BTC/JPY',
        'LTC/BTC',
        'USD/SLL',
    ]
    symbols.each do |s|
      if keys.include?(s)
        symbol = s
        break
      end
    end
  
    if !symbol.include?('.d')
      await{ test_symbol(exchange, symbol)}
    end
  
    # ..........................................................................
    # private API

    # if (not hasattr(exchange, 'apiKey') or (len(exchange.apiKey) < 1)):
    #     return
    #
    # # move to testnet/sandbox if possible before accessing the balance if possible
    # # if 'test' in exchange.urls:
    # #     exchange.urls['api'] = exchange.urls['test']
    #
    # await exchange.fetch_balance()
    # dump(green(exchange.id), 'fetched balance')
    #
    # await asyncio.sleep(exchange.rateLimit / 1000)
    #
    # if exchange.has['fetchOrders']:
    #     try:
    #         orders = await exchange.fetch_orders(symbol)
    #         dump(green(exchange.id), 'fetched', green(str(len(orders))), 'orders')
    #     except (ccxt.ExchangeError, ccxt.NotSupported) as e:
    #         dump_error(yellow('[' + type(e).__name__ + ']'), e.args)
  end

  async def try_all_proxies(exchange)
    begin
      await{ load_exchange( exchange ) }
      await{ test_exchange( exchange ) }
    rescue Ccxt::RequestTimeout => e
      puts e 
    rescue Ccxt::NotSupported => e
      puts e
    rescue Ccxt::DDoSProtection => e
      puts e
    rescue Ccxt::ExchangeNotAvailable => e
      puts e
    rescue Ccxt::AuthenticationError => e
      puts e
    rescue Ccxt::ExchangeError => e
      puts e
    else
      # no exception
      return true
    end
  end

  async def main
    # gotta catch 'em all.
    @exchanges.each do |id, exchange|
      if exchange.instance_variable_defined?("@skip") && exchange.skip
        dump(green( exchange.id + ' skipped.'))
      else
        try_all_proxies(exchange)
      end
    end
    return true
  end
  
  def run

    # load the api keys from config
    config = JSON.load( File.read '../examples/rb/keys.json' )

    dump("Sorted order: ", *Ccxt.exchanges.sort)

    # instantiate all exchanges
    Ccxt.exchanges.sort.each do |id|
      if id == 'theocean' || id == 'theocean1'
        next
      end

      exchange_config = {'verbose' => false }
      exchange_config.update( { 'enableRateLimit' => true })
      exchange_config.update(config[id]) if config.key?(id)
      @exchanges[id] = Ccxt[id].new(exchange_config)
    end
    
    Async do
      main
    end.wait
  end
end


TestAsync.new.run