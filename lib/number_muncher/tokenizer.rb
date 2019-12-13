module NumberMuncher
  class Tokenizer
    INVALID_REGEX = /(?![#{NumberMuncher::Unicode::VALUES.join}])\S+/.freeze

    include Enumerable

    delegate :each, :empty?, to: :tokens

    attr_reader :string, :tokens

    def initialize(string)
      @string = string
    end

    def call(raise: false)
      @tokens = []
      scan(raise) until scanner.eos?
      tokens
    end

  private

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
        Token::Float.scan(scanner) ||
        Token::Int.scan(scanner)
    end

    def handle_invalid(raise)
      if raise
        raise InvalidNumber if scanner.match?(INVALID_REGEX)
      else
        scanner.skip(INVALID_REGEX)
      end
    end
  end
end
