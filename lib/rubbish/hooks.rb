module Rubbish
  module Hooks
    # Raise this to cancel the callback chain
    class Cancel < Exception; end

    # Raise this to alter the arguments to successive callbacks in the chain
    class Arguments < Exception
      attr_reader :args

      def initialize *args
        @args = args
      end
    end

    def hooks
      @hooks ||= Hash.new { |h, k| h[k] = [] }
    end

    def on(sym, &block)
      hooks[sym].push(block) unless block.nil?
    end

    def before(sym, &block)
      hooks[sym].unshift(block) unless block.nil?
    end

    def off(sym)
      hooks.delete(sym)
    end

    def hook(sym, *args)
      hooks[sym].each do |hook|
        begin
          hook.call(*args)
        rescue Arguments => e
          args = e.args
        rescue Cancel
          break
        end
      end
    end
  end
end