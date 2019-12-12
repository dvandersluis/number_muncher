require 'active_support/core_ext/object/blank'

module NumberMuncher
  class StringParser
    UNICODE_FRACTIONS = {
      '½' => Rational(1, 2),
      '⅓' => Rational(1, 3),
      '⅔' => Rational(2, 3),
      '¼' => Rational(1, 4),
      '¾' => Rational(3, 4),
      '⅕' => Rational(1, 5),
      '⅖' => Rational(2, 5),
      '⅗' => Rational(3, 5),
      '⅘' => Rational(4, 5),
      '⅙' => Rational(1, 6),
      '⅚' => Rational(5, 6),
      '⅐' => Rational(1, 7),
      '⅛' => Rational(1, 8),
      '⅜' => Rational(3, 8),
      '⅝' => Rational(5, 8),
      '⅞' => Rational(7, 8),
      '⅑' => Rational(1, 9),
      '⅒' => Rational(1, 10)
    }.freeze

    FRACTIONS_REGEX = Regexp.union(UNICODE_FRACTIONS.keys)
    SPLIT_REGEX = -> (allow) { /(?<!#{allow})(?!(#{allow}|\w))/ }

    def initialize(string, thousands_separator: ',', decimal_separator: '.')
      raise ArgumentError, 'thousands_separator cannot be the same as decimal_separator' if thousands_separator == decimal_separator

      @thousands_separator = thousands_separator
      @decimal_separator = decimal_separator
      @string = normalize(string)
    end

    def parse
      return nil if parts.empty?

      result = parts.map(&method(:convert)).compact.inject(:+)
      result *= -1 if negative?
      result
    rescue ArgumentError, ZeroDivisionError
      raise CannotParseError, "#{string} is not valid input to parse."
    end

  private

    attr_accessor :negative
    attr_reader :string, :thousands_separator, :decimal_separator

    alias_method :negative?, :negative

    def convert(string)
      UNICODE_FRACTIONS[string] || Rational(string)
    end

    def normalize(string)
      return nil if string.blank?

      self.negative = string.start_with?('-')

      string.gsub(%r{\s*/\s*}, '/').gsub(/\s+/, ' ').
        delete(thousands_separator).
        delete('-').
        tr(decimal_separator, '.')
    end

    def parts
      @parts = begin
        allow = %r{[/#{decimal_separator}-]}
        string.split(SPLIT_REGEX.call(allow)).select(&:present?)
      end
    end
  end
end
