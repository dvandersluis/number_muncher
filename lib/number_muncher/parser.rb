module NumberMuncher
  class Parser
    def initialize(value)
      @value = value
    end

    def call
      return Numeric.new(value) unless value.is_a?(String)
      return nil if tokens.empty?
      raise InvalidParseExpression, 'parse requires a single number' unless tokens.size == 1

      tokens.first.value

    rescue ArgumentError, ZeroDivisionError
      raise InvalidNumber, "#{value} is not valid input to parse."
    end

  private

    attr_reader :value

    def tokens
      NumberMuncher::Tokenizer.new(value).call(raise: true)
    end
  end
end
