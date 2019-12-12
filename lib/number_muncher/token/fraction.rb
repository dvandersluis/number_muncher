module NumberMuncher
  class Token
    class Fraction < Token
      REGEX = %r{-?(\d+\s*/\s*\d+|#{NumberMuncher::Unicode::REGEX})}.freeze

      def initialize(value)
        super
        @numerator, @denominator = self.value.split('/')
        raise ZeroDivisionError if denominator == '0'
      end

      def value
        super.gsub(/[\s-]+/, '')
      end

      def to_r
        NumberMuncher::Unicode::MAPPING[value] || Rational(numerator, denominator)
      end

    private

      attr_reader :numerator, :denominator
    end
  end
end
