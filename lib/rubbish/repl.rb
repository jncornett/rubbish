require 'readline'
require 'rubbish/sandbox'

module Rubbish
  class REPL
    def initialize config = nil
      @config = config || {}
      @sandbox = Sandbox.new(@config)
    end

    def start
      done = false
      until done
        begin
          buf = Readline.readline(@config.prompt, true)
          puts @sandbox.run_code(buf)
        rescue Interrupt
          done = true
        end
      end
    end
  end
end
