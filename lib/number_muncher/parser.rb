module NumberMuncher
  class Parser
    def initialize(**options)
      @options = options
    end

    def parse(string)
      tokenizer = NumberMuncher::Tokenizer.new(string, **@options)
      tokens = tokenizer.tokenize(raise: true)
      return nil if tokens.empty?

      result = tokens.map(&:to_r).inject(:+)
      result *= -1 if tokenizer.negative?
      result

    rescue ArgumentError, ZeroDivisionError
      raise CannotParseError, "#{string} is not valid input to parse."
    end
  end
end
