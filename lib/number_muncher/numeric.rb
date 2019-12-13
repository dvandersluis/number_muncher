module NumberMuncher
  class Numeric < SimpleDelegator
    ARITHMETIC_OPERATORS = %i(+ - * / **).freeze

    alias_method :rational, :__getobj__

    def initialize(value)
      super(parse(value))
    end

    def to_r
      rational
    end

    ARITHMETIC_OPERATORS.each do |operator|
      define_method(operator) do |other|
        self.class.new(to_r.send(operator, other.to_r))
      end
    end

    def round(to = nil)
      return self unless to

      to = Numeric.new(to)
      raise IllegalRoundValue, 'cannot round to nearest 0' if to.zero?

      to * (self / to).to_f.round
    end

    def to_fraction(**opts)
      ToFraction.new(opts).call(self)
    end

  private

    def parse(value)
      Rational(value)

    rescue ArgumentError
      Parser.new(value).call.to_r
    end
  end
end
