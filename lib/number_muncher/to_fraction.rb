module NumberMuncher
  class ToFraction
    def initialize(unicode: true, separator: nil, factor: 0.001)
      @unicode = unicode
      @separator = separator
      @factor = factor
    end

    def call(number, round_to: nil)
      return '' unless number

      @rational = rationalize(number, round_to)
      return '0' if rational.zero?

      separator = glyph ? '' : ' '
      parts = [whole, glyph || fraction].compact
      parts.empty? ? '0' : "#{sign}#{parts.map(&:to_s).join(separator)}"
    end

  private

    attr_reader :rational, :unicode, :separator, :factor
    alias_method :unicode?, :unicode

    def rationalize(number, round_to)
      number = Rational(number)
      (round_to ? round(number, Rational(round_to)) : number).rationalize(factor)
    end

    def round(number, round_to)
      raise IllegalRoundValue, 'round must not be 0' if round_to.zero?

      (number / round_to).round * round_to
    end

    def glyph
      return nil unless unicode? && fraction

      NumberMuncher::Unicode::MAPPING.key(fraction)
    end

    def whole
      return if (-1.0.next_float...1).cover?(rational)

      (rational.numerator / rational.denominator).abs
    end

    def fraction
      value = (whole ? rational.abs - whole : rational).abs
      value.zero? ? nil : value
    end

    def sign
      '-' if rational.negative?
    end
  end
end
