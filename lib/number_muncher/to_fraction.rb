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
      "#{sign}#{parts.map(&:to_s).join(separator)}"
    end

  private

    attr_reader :rational, :unicode, :separator, :factor
    alias_method :unicode?, :unicode

    def rationalize(number, round_to)
      Numeric.new(number).round(round_to).rationalize(factor)
    end

    def glyph
      return nil unless unicode? && fraction

      Unicode::MAPPING.key(fraction)
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
