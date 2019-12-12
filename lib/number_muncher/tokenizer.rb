module NumberMuncher
  class Tokenizer
    INVALID_REGEX = /(?![#{NumberMuncher::Unicode::VALUES.join}])\S+/.freeze

    include Enumerable

    delegate :each, :empty?, to: :tokens

    attr_reader :string, :tokens

    def initialize(string, thousands_separator: ',', decimal_separator: '.')
      raise ArgumentError, 'thousands_separator cannot be the same as decimal_separator' if thousands_separator == decimal_separator

      @thousands_separator = thousands_separator
      @decimal_separator = decimal_separator

      @string = string
    end

    def tokenize(raise: false)
      @tokens = []
      scan(raise) until scanner.eos?
      tokens
    end

    def ==(other)
      tokens == other
    end

    def negative?
      count = tokens.count(&:negative?)
      (-1)**count == -1
    end

  private

    attr_reader :thousands_separator, :decimal_separator

    def scanner
      @scanner ||= StringScanner.new(string)
    end

    def scan(raise)
      scanner.skip(/\s+/)
      token = next_token
      tokens << token if token
      handle_invalid(raise)

    rescue ZeroDivisionError
      Kernel.raise if raise
    end

    def next_token
      Token::Fraction.scan(scanner) ||
        Token::Float.scan(scanner, decimal_separator, thousands_separator) ||
        Token::Int.scan(scanner, thousands_separator)
    end

    def handle_invalid(raise)
      if raise
        raise CannotParseError if scanner.match?(INVALID_REGEX)
      else
        scanner.skip(INVALID_REGEX)
      end
    end
  end
end
