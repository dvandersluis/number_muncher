RSpec.describe NumberMuncher::Parser do
  subject { described_class }

  describe '.call' do
    let(:options) { { thousands_separator: '.', decimal_separator: ',' } }

    context 'when given invalid input' do
      it 'raises an exception' do
        expect { described_class.new('a').call }.to raise_error(NumberMuncher::InvalidNumber)
        expect { described_class.new('a/2').call }.to raise_error(NumberMuncher::InvalidNumber)
        expect { described_class.new('1/2 abc').call }.to raise_error(NumberMuncher::InvalidNumber)
        expect { described_class.new('abc 1/2').call }.to raise_error(NumberMuncher::InvalidNumber)
        expect { described_class.new('1/0').call }.to raise_error(NumberMuncher::InvalidNumber)
      end
    end

    context 'when given a Rational' do
      it 'passes it through' do
        expect(1/2r).to parse_to(1/2r)
      end
    end

    context 'when given a Float' do
      it 'passes it through' do
        expect(Math::PI).to parse_to(Math::PI)
      end
    end

    context 'when given a Numeric' do
      let(:numeric) { NumberMuncher::Numeric.new(5) }

      it 'passes it through' do
        expect(numeric).to parse_to(numeric)
      end
    end

    context 'when given a phrase' do
      it 'raises an exception' do
        expect { described_class.new('1 2').call }.to raise_error(NumberMuncher::InvalidParseExpression)
      end
    end

    context 'when given a single fraction' do
      it 'parses it' do
        expect('1/2').to parse_to(1/2r)
      end

      it 'handles negative fractions' do
        expect('-3/8').to parse_to(-3/8r)
      end

      it 'ignores extra whitespace' do
        expect('3 / 8').to parse_to(3/8r)
      end
    end

    context 'when given a mixed fraction' do
      it 'parses it' do
        expect('1 7/8').to parse_to(15/8r)
      end

      it 'handles negative fractions' do
        expect('-3 1/2').to parse_to(-7/2r)
      end

      it 'ignores repeated whitespace' do
        expect('9   3/7').to parse_to(66/7r)
        expect('9   3    /   7').to parse_to(66/7r)
      end

      it 'handles separators' do
        expect('1,000 1/2').to parse_to(2001/2r)
      end

      it 'when the thousands separator is different' do
        expect('1.000 1/2').to parse_to(2001/2r).with_options(options)
      end
    end

    context 'when given a decimal' do
      it 'parses it' do
        expect('3.75').to parse_to(15/4r)
      end

      it 'handles separators' do
        expect('1,000.5').to parse_to(2001/2r)
      end

      it 'handles negative decimals' do
        expect('-3.8').to parse_to(-19/5r)
      end

      it 'parses a decimal without leading 0' do
        expect('.5').to parse_to(1/2r)
      end

      it 'when the separators are different' do
        expect('1.000,5').to parse_to(2001/2r).with_options(options)
      end
    end

    context 'when given unicode fractions' do
      it 'converts them' do # rubocop:disable RSpec/ExampleLength
        expect('½').to parse_to(1/2r)
        expect('⅓').to parse_to(1/3r)
        expect('⅔').to parse_to(2/3r)
        expect('¼').to parse_to(1/4r)
        expect('¾').to parse_to(3/4r)
        expect('⅕').to parse_to(1/5r)
        expect('⅖').to parse_to(2/5r)
        expect('⅗').to parse_to(3/5r)
        expect('⅘').to parse_to(4/5r)
        expect('⅙').to parse_to(1/6r)
        expect('⅚').to parse_to(5/6r)
        expect('⅐').to parse_to(1/7r)
        expect('⅛').to parse_to(1/8r)
        expect('⅜').to parse_to(3/8r)
        expect('⅝').to parse_to(5/8r)
        expect('⅞').to parse_to(7/8r)
        expect('⅑').to parse_to(1/9r)
        expect('⅒').to parse_to(1/10r)
      end

      it 'handles negative fractions' do
        expect('-⅙').to parse_to(-1/6r)
      end

      it 'converts mixed fractions' do
        expect('1½').to parse_to(3/2r)
      end
    end
  end
end
