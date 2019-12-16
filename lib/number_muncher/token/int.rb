module NumberMuncher
  module Token
    class Int < Base
      def self.regex
        /-?(\d{1,3}(#{Regexp.quote(NumberMuncher.thousands_separator)}\d{3})+|\d+)/
      end

      def text
        super.delete(NumberMuncher.thousands_separator)
      end

      def int?
        true
      end
    end
  end
end
