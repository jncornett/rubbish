
module Rubbish
  class Config
    DEFAULTS = {
      prompt: '> '
    }.freeze

    def initialize values = {}
      @values = values
    end

    def prompt
      @values[:prompt] || DEFAULTS[:prompt]
    end

    def prompt= value
      @values[:prompt] = value
    end
  end
end
