module NumberMuncher
  class Parser
    def self.parse(string)
      tokenizer = NumberMuncher::Tokenizer.new(string)
      tokens = tokenizer.tokenize(raise: true)
      return nil if tokens.empty?

      raise InvalidParseExpression, 'parse requires a single number' unless tokens.size == 1

      tokens.first.to_r

    rescue ArgumentError, ZeroDivisionError
      raise InvalidNumber, "#{string} is not valid input to parse."
    end
  end
end
