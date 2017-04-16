require 'readline'
require 'rubbish/hooks'

module Rubbish
  class REPL

    include Hooks

    def initialize
      @prompt = 'λ. '
      @alt_prompt = ':: '
    end

    def setup_completion_engine
      Readline.completion_append_character = ' '
      Readline.completion_proc = proc do |s|
        (methods + instance_variables).map(&:to_s).select do |sym|
          sym.start_with? s
        end
      end
    end

    def install_hooks
      installed = []
      off :before_eval
      installed << (on :before_eval do
        @pwd = Dir.pwd
      end)
      off :after_eval
      installed << (on :after_eval do |result|
        if result[:ok]
          puts result[:value] unless result[:value].nil?
        else
          puts result[:error]
        end
      end)
      "#{installed.length} hooks installed"
    end

    def start
      setup_completion_engine
      install_hooks
      done = false
      until done
        begin
          hook :before_eval
          result = eval_lines
          hook :after_eval, result
        rescue Interrupt
          done = true
        end
      end
    end

    def eval_lines
      alt_prompt = false
      lines = []
      while true
        hook :before_readline
        lines << Readline.readline(alt_prompt ? @alt_prompt : @prompt, true)
        hook :line, lines
        begin
          value = instance_eval(lines.join("\n"))
          return { ok: true, value: value }
        rescue StandardError => e
          if SyntaxError === e && lines.last.strip.length > 0
            hook :syntax_error, e, lines
            alt_prompt = true
          else
            hook :exception, e
            return { ok: false, error: e }
          end
        end
      end
    end

  end
end
