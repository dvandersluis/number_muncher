module NumberMuncher
  class Token
    class Fraction < Token
      delegate :numerator, :denominator, to: :to_r

      def self.regex
        %r{
          (?<sign>-)?
          (?<whole>#{Int.regex}\s*)?
          (
            (?<numerator>\d+)\s*/\s*(?<denominator>\d+)
            |
            (?<unicode>#{NumberMuncher::Unicode::REGEX})
          )
        }x
      end

      def initialize(value, scanner)
        super
        raise ZeroDivisionError if denominator == '0'
      end

      def to_r
        @to_r ||= parse
      end

      def fraction?
        true
      end

    private

      def parse
        sign, whole, numerator, denominator, unicode = scanner.captures.map(&:presence)

        value = unicode ? NumberMuncher::Unicode::MAPPING[unicode] : Rational(numerator, denominator)
        value += Int.new(whole).to_r if whole
        value *= -1 if sign
        value
      end
    end
  end
end
