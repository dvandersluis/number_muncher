module NumberMuncher
  class Token
    class Fraction < Token
      delegate :numerator, :denominator, to: :value

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

      def initialize(*)
        super
        raise ZeroDivisionError if denominator == '0'
      end

      def value
        @value ||= parse
      end

      def fraction?
        true
      end

    private

      def parse
        sign, whole, numerator, denominator, unicode = captures

        value = unicode ? Unicode::MAPPING[unicode] : Rational(numerator, denominator)
        value += Int.new(whole).value if whole
        value *= -1 if sign
        value
      end

      def captures
        if scanner.respond_to?(:captures)
          scanner.captures.map(&:presence)
        else
          match = self.class.regex.match(text)

          match.regexp.named_captures.each_with_object([]) do |(capture, _), arr|
            arr << match[capture]
          end
        end
      end
    end
  end
end
