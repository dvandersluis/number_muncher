module NumberMuncher
  class Token
    class Fraction < Token
      REGEX = %r{-?(\d+\s*/\s*\d+|#{NumberMuncher::Unicode::REGEX})}.freeze

      def value
        super.gsub(/[\s-]+/, '')
      end

      def to_r
        NumberMuncher::Unicode::MAPPING[value] || Rational(*value.split('/'))
      end
    end
  end
end
