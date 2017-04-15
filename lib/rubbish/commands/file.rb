module Rubbish
  module Commands
    module File
      def ls
        raise 'Not implemented'
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
