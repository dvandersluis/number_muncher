module NumberMuncher
  module Token
    class Float < Base
      def self.regex
        /(#{Int.regex}|-?)#{Regexp.quote(NumberMuncher.decimal_separator)}\d+/
      end

      def text
        super.delete(NumberMuncher.thousands_separator).tr(NumberMuncher.decimal_separator, '.')
      end

      def float?
        true
      end
    end
  end
end
