module NumberMuncher
  class Token
    class Float < Token
      REGEX = lambda do |decimal_sep, thousands_sep|
        /(#{Int::REGEX.call(thousands_sep)}|-?)#{Regexp.quote(decimal_sep)}\d+/
      end

      def initialize(value, decimal_separator, thousands_separator)
        super(value)
        @decimal_separator = decimal_separator
        @thousands_separator = thousands_separator
      end

      def value
        super.delete(thousands_separator).tr(decimal_separator, '.').delete('-')
      end

    private

      attr_reader :decimal_separator, :thousands_separator
    end
  end
end
