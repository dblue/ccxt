require 'async'
require 'async/queue'
require 'async/await'

module Ccxt
  class Throttle
    include Async::Await
    
    attr_accessor :queue
    attr_accessor :settings
    
    def initialize(config={})
      @settings = {
        'lastTimestamp' => Time.now,
        'numTokens' => 0,
        'running' => false,
        'delay' => 0.001,
        'refillRate' => 0.001,
        'defaultCost' => 1.000,
        'capacity' => 1.000,
        # 'task' => Async::Task.current
      }
      @settings.merge!(config)
      @queue = []
    end
    
    async def run
      # puts "throttle#run: Entering throttle"
      if !settings['running']
        settings['running'] = true

        while !queue.empty?
          # puts "throttle#run: Queued items: #{queue.inspect}"
          now = Time.now
          elapsed = (now - settings['lastTimestamp'])
          settings['lastTimestamp'] = Time.now
          settings['numTokens'] = [settings['capacity'], settings['numTokens'] + elapsed * settings['refillRate'] * 1000].min
          if settings['numTokens'] > 0
            cost = queue.shift
            settings['numTokens'] -= cost ? cost : settings['defaultCost']
            # puts " * Cost is #{cost.inspect}."
#             puts " * numTokens is #{settings['numTokens']}."
          end
          # puts " - Waiting for #{settings['delay']} seconds because I only have #{settings['numTokens']}."
          Async {|task| task.sleep(settings['delay'])}
        end
        settings['running'] = false
      end
    end

    def throttle(cost=nil)
      queue.push( cost )
      return run
    end
  end
end

