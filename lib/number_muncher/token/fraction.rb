module NumberMuncher
  class Token
    class Fraction < Token
      def self.regex
        %r{
          (?<sign>-)?
          (?:(?<whole>#{Int.regex})(?:-|\s*))??
          (
            (?<numerator>\d+)\s*/\s*(?<denominator>\d+)
            |
            (?<unicode>#{Unicode::REGEX})
          )
        }x
      end

      def fraction?
        true
      end

    private

      def parse
        sign, whole, numerator, denominator, unicode = captures

        r = unicode ? Unicode::MAPPING[unicode] : Rational(numerator, denominator)
        r += Int.new(whole).to_r if whole
        r *= -1 if sign
        r
      end
    end
  end
end
