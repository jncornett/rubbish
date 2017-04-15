module Rubbish
  module Commands
    module Color
      COLORS = {
        red: "\x1b[31m",
        green: "\x1b[32m",
        blue: "\x1b[34m",
        reset: "\x1b[0m"
      }

      def color c
        case c
        when Symbol then COLORS[c]
        end
      end
    end
  end
end
