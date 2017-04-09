require 'readline'

module Rubbish
  class REPL
    def initialize config
      @config = config
    end

    def start
      until done
        buf = Readline.readline(@config.prompt, true)
        p buf
      end
    end

    def done
      false
    end
  end
end
