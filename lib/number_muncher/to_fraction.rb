module NumberMuncher
  class ToFraction
    def initialize(unicode: true, separator: nil, factor: 0.001)
      @unicode = unicode
      @separator = separator
      @factor = factor
    end

    def call(number)
      return '' unless number

      @rational = rationalize(number)
      return '0' if rational.zero?

      separator = glyph ? '' : ' '
      parts = [whole, glyph || fraction].compact
      parts.empty? ? '0' : "#{sign}#{parts.map(&:to_s).join(separator)}"
    end

  private

    attr_reader :rational, :unicode, :separator, :factor
    alias_method :unicode?, :unicode

    def rationalize(number)
      Rational(number).rationalize(factor)
    end

    def glyph
      return nil unless unicode? && fraction

      NumberMuncher::Unicode::MAPPING.key(fraction)
    end

    def whole
      return if (-1..1).cover?(rational)

      (rational.numerator / rational.denominator).abs
    end

    def fraction
      (whole ? rational.abs - whole : rational).abs.then { |f| f.zero? ? nil : f }
    end

    def sign
      '-' if rational.negative?
    end
  end
end