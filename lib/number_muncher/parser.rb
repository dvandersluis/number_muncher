module NumberMuncher
  class Parser
    def self.call(string)
      tokens = NumberMuncher::Tokenizer.new(string).call(raise: true)
      return nil if tokens.empty?

      raise InvalidParseExpression, 'parse requires a single number' unless tokens.size == 1

      tokens.first.value

    rescue ArgumentError, ZeroDivisionError
      raise InvalidNumber, "#{string} is not valid input to parse."
    end
  end
end
