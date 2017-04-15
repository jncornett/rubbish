module Rubbish
  module Commands
    module File
      def ls *patterns
        patterns << '*' if patterns.empty?
        patterns.map do |p|
          Dir[p]
        end.flatten
      end

      def cd arg = nil
        Dir.chdir arg
      end

      def pwd
        Dir.pwd
      end
    end
  end
end
