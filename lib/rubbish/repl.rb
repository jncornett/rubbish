require 'readline'

module Rubbish
  class REPL
    def initialize
      @prompt = 'λ. '
      @alt_prompt = ':: '
    end

    def configure_completion
      Readline.completion_append_character = ' '
      Readline.completion_proc = proc do |s|
        (methods + instance_variables).map(&:to_s).select do |sym|
          sym.start_with? s
        end
      end
    end

    def start
      configure_completion
      done = false
      until done
        begin
          on_before_eval
          result = eval_lines
          on_result result
        rescue Interrupt
          done = true
        end
      end
    end

    def eval_lines
      alt_prompt = false
      lines = []
      while true
        lines << Readline.readline(alt_prompt ? on_alt_prompt : on_prompt, true)
        begin
          return {
            ok: true,
            value: instance_eval(lines.join("\n"))
          }
        rescue Exception => e
          if SyntaxError === e && lines.last.strip.length > 0
            on_repl_syntax_error e, lines
            alt_prompt = true
          else
            return {
              ok: false,
              error: e
            }
          end
        end
      end
    end

    def on_before_eval
      @pwd = Dir.pwd
    end

    def on_prompt
      @prompt
    end

    def on_alt_prompt
      @alt_prompt
    end

    def on_repl_syntax_error e, lines; end

    def on_repl_exception e; end

    def on_result r
      if r[:ok]
        on_ok_result r
      else
        on_error_result r
      end
    end

    def on_ok_result r
      @last = r[:value]
      puts r[:value] if r[:value]
    end

    def on_error_result r
      puts r[:error]
    end

    def debug
      class << self
        def on_repl_syntax_error e, lines
          puts "Repl syntax error: #{e}"
          puts "Lines: #{lines}"
        end

        def on_repl_exception e
          puts "Repl exception: #{e}"
        end
      end
    end
  end
end
