require 'readline'

module Rubbish
  class REPL
    def initialize config
      @config = config
      @sandbox = Object.new
    end

    def start
      done = false
      until done
        begin
          buf = Readline.readline(@config.prompt, true)
          @sandbox.instance_eval(buf)
        rescue Interrupt
          done = true
        end
      end
    end
  end
end
