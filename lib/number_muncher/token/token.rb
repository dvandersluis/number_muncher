module NumberMuncher
  class Token
    class Token
      attr_reader :text

      def self.scan(scanner)
        new(scanner.matched, scanner) if scanner.scan(regex)
      end

      def initialize(text, scanner = nil)
        @text = text
        @scanner = scanner
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

      def to_r
        Rational(text)
      end

      def to_a
        [
          self.class.name.demodulize.underscore.to_sym,
          to_r
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

      attr_reader :scanner
    end
  end
end
