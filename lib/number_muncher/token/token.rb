module NumberMuncher
  class Token
    class Token
      attr_reader :value

      def self.scan(scanner, *opts)
        regex = self::REGEX
        regex = regex.call(*opts) if regex.respond_to?(:call)

        new(scanner.matched, *opts) if scanner.scan(regex)
      end

      def initialize(value)
        @raw_value = @value = value
      end

      def negative?
        @raw_value.start_with?('-')
      end

      def valid?
        true
      end

      def to_r
        Rational(value)
      end

      def to_a
        [
          self.class.name.demodulize.underscore.to_sym,
          to_r,
          negative?
        ]
      end

      def ==(other)
        return to_a == other if other.is_a?(Array)

        super
      end
    end
  end
end
