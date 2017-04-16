module Rubbish
  module Hooks
    # Raise this to cancel the callback chain
    class Cancel < Exception; end

    # Raise this to alter the arguments to successive callbacks in the chain
    class Arguments < Exception
      attr_reader :args
      attr_reader :rv

      def initialize args, rv = nil
        @args = args
        @rv = rv
      end
    end

    def hooks
      @hooks ||= Hash.new { |h, k| h[k] = [] }
    end

    def on(sym, &block)
      hook :register_hook, sym
      hooks[sym].push(block) unless block.nil?
    end

    def before(sym, &block)
      hook :register_before_hook, sym
      hooks[sym].unshift(block) unless block.nil?
    end

    def off(sym)
      hook :unregister_hook, sym
      hooks.delete(sym)
    end

    def hook(sym, *args)
      hook :trigger_hook, sym, *args unless sym == :trigger_hook  # Don't want to trigger it twice
      hooks[sym].map do |block|
        begin
          block.call(*args)
        rescue Arguments => e
          args = e.args
          e.rv
        rescue Cancel
          break []
        end
      end.last
    end
  end
end