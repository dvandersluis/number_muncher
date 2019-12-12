RSpec.describe NumberMuncher::StringParser do
  subject { described_class }

  describe '.parse' do
    let(:options) { { thousands_separator: '.', decimal_separator: ',' } }

    context 'when given invalid input' do
      it 'raises an exception' do
        expect { described_class.new('a').parse }.to raise_error(NumberMuncher::CannotParseError)
        expect { described_class.new('a/2').parse }.to raise_error(NumberMuncher::CannotParseError)
        expect { described_class.new('1/2 abc').parse }.to raise_error(NumberMuncher::CannotParseError)
        expect { described_class.new('abc 1/2').parse }.to raise_error(NumberMuncher::CannotParseError)
      end
    end

    context 'when given a single fraction' do
      it 'parses it' do
        expect('1/2').to parse_to(Rational(1, 2))
      end

      it 'handles negative fractions' do
        expect('-3/8').to parse_to(Rational(-3, 8))
      end

      it 'ignores extra whitespace' do
        expect('3 / 8').to parse_to(Rational(3, 8))
      end
    end

    context 'when given a mixed fraction' do
      it 'parses it' do
        expect('1 7/8').to parse_to(Rational(15, 8))
      end

      it 'handles negative fractions' do
        expect('-3 1/2').to parse_to(Rational(-7, 2))
      end

      it 'ignores repeated whitespace' do
        expect('9   3/7').to parse_to(Rational(66, 7))
        expect('9   3    /   7').to parse_to(Rational(66, 7))
      end

      it 'handles separators' do
        expect('1,000 1/2').to parse_to(Rational(2001, 2))
      end

      it 'when the thousands separator is different' do
        expect('1.000 1/2').to parse_to(Rational(2001, 2)).with_options(options)
      end
    end

    context 'when given a decimal' do
      it 'parses it' do
        expect('3.75').to parse_to(Rational(15, 4))
      end

      it 'handles separators' do
        expect('1,000.5').to parse_to(Rational(2001, 2))
      end

      it 'handles negative decimals' do
        expect('-3.8').to parse_to(Rational(-19, 5))
      end

      it 'parses a decimal without leading 0' do
        expect('.5').to parse_to(Rational(1, 2))
      end

      it 'when the separators are different' do
        expect('1.000,5').to parse_to(Rational(2001, 2)).with_options(options)
      end
    end

    context 'when given unicode fractions' do
      it 'converts them' do # rubocop:disable RSpec/ExampleLength
        expect('½').to parse_to(Rational(1, 2))
        expect('⅓').to parse_to(Rational(1, 3))
        expect('⅔').to parse_to(Rational(2, 3))
        expect('¼').to parse_to(Rational(1, 4))
        expect('¾').to parse_to(Rational(3, 4))
        expect('⅕').to parse_to(Rational(1, 5))
        expect('⅖').to parse_to(Rational(2, 5))
        expect('⅗').to parse_to(Rational(3, 5))
        expect('⅘').to parse_to(Rational(4, 5))
        expect('⅙').to parse_to(Rational(1, 6))
        expect('⅚').to parse_to(Rational(5, 6))
        expect('⅐').to parse_to(Rational(1, 7))
        expect('⅛').to parse_to(Rational(1, 8))
        expect('⅜').to parse_to(Rational(3, 8))
        expect('⅝').to parse_to(Rational(5, 8))
        expect('⅞').to parse_to(Rational(7, 8))
        expect('⅑').to parse_to(Rational(1, 9))
        expect('⅒').to parse_to(Rational(1, 10))
      end

      it 'handles negative fractions' do
        expect('-⅙').to parse_to(Rational(-1, 6))
      end

      it 'converts mixed fractions' do
        expect('1½').to parse_to(Rational(3, 2))
      end
    end
  end
end
