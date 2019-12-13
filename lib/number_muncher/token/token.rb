module NumberMuncher
  class Token
    class Token
      attr_reader :value, :text
      delegate :to_r, to: :value

      def self.scan(scanner)
        new(scanner.matched, captures(scanner)) if scanner.scan(regex)
      end

      def self.captures(scanner)
        if scanner.respond_to?(:captures)
          scanner.captures.map(&:presence)
        else
          match = self.class.regex.match(text)

          match.regexp.named_captures.each_with_object([]) do |(capture, _), arr|
            arr << match[capture]
          end
        end
      end

      def initialize(text, captures = nil)
        @text = text
        @captures = captures
        @value = Numeric.new(parse)
      end

      def int?
        false
      end

      def float?
        false
      end

      def fraction?
        false
      end

      def to_a
        [
          self.class.name.demodulize.underscore.to_sym,
          value
        ]
      end

      def ==(other)
        return to_a == other if other.is_a?(Array)

        super
      end

      def inspect
        to_a.to_s
      end

    private

      def parse
        Rational(text)
      end

      attr_reader :captures
    end
  end
end
