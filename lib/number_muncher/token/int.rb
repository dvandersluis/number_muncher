module NumberMuncher
  class Token
    class Int < Token
      REGEX = -> (thousands_sep) { /-?(\d{1,3}(#{Regexp.quote(thousands_sep)}\d{3})+|\d+)/ }

      def initialize(value, thousands_separator)
        super(value)
        @thousands_separator = thousands_separator
      end

      def value
        super.delete(thousands_separator).delete('-')
      end

    private

      attr_reader :thousands_separator
    end
  end
end
