require 'set'

module Rubbish

  USABLE_MODULES ||= Set.new

  def self.usable_modules
    USABLE_MODULES.to_a
  end

  module Usable
    def self.included includer
      USABLE_MODULES << includer
    end
  end

  module Use
    def use path
      return unless require path
      (USABLE_MODULES - included_modules).each { |m| include m }
    end
  end

end