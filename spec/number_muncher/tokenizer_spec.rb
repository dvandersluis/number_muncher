RSpec.describe NumberMuncher::Tokenizer do
  context 'invalid' do
    context 'abcd' do
      subject { described_class.new('abcd').tokenize }

      it { is_expected.to be_empty }
    end
  end

  context 'integers' do
    context '1' do
      subject { described_class.new('1').tokenize }

      it { is_expected.to eq([[:int, 1, false]]) }
    end

    context '-1' do
      subject { described_class.new('-1').tokenize }

      it { is_expected.to eq([[:int, 1, true]]) }
    end

    context '1000' do
      subject { described_class.new('1000').tokenize }

      it { is_expected.to eq([[:int, 1000, false]]) }
    end

    context '1,000' do
      subject { described_class.new('1,000').tokenize }

      it { is_expected.to eq([[:int, 1000, false]]) }
    end

    context '-1,000' do
      subject { described_class.new('-1,000').tokenize }

      it { is_expected.to eq([[:int, 1000, true]]) }
    end
  end

  context 'decimals' do
    context '-.5' do
      subject { described_class.new('-.5').tokenize }

      it { is_expected.to eq([[:float, 1/2r, true]]) }
    end

    context '-0.5' do
      subject { described_class.new('-0.5').tokenize }

      it { is_expected.to eq([[:float, 1/2r, true]]) }
    end

    context '1000.005' do
      subject { described_class.new('1000.005').tokenize }

      it { is_expected.to eq([[:float, 1000.005, false]]) }
    end

    context '-1,000.345' do
      subject { described_class.new('-1,000.345').tokenize }

      it { is_expected.to eq([[:float, 1000.345, true]]) }
    end
  end

  context 'fractions' do
    context '½' do
      subject { described_class.new('½').tokenize }

      it { is_expected.to eq([[:fraction, 1/2r, false]]) }
    end

    context '⅐' do
      subject { described_class.new('⅐').tokenize }

      it { is_expected.to eq([[:fraction, 1/7r, false]]) }
    end

    context '-½' do
      subject { described_class.new('-½').tokenize }

      it { is_expected.to eq([[:fraction, 1/2r, true]]) }
    end

    context '3/8' do
      subject { described_class.new('3/8').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r, false]]) }
    end

    context '-3/8' do
      subject { described_class.new('-3/8').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r, true]]) }
    end

    context '3 / 8' do
      subject { described_class.new('3 / 8').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r, false]]) }
    end
  end

  context 'mixed fractions' do
    context '1,000,000 ⅜' do
      subject { described_class.new('1,000,000 ⅜').tokenize }

      it {
        expect(subject).to eq([
          [:int, 1_000_000, false],
          [:fraction, 3/8r, false]
        ])
      }
    end

    context '-1½' do
      subject { described_class.new('-1½').tokenize }

      it {
        expect(subject).to eq([
          [:int, 1, true],
          [:fraction, 1/2r, false]
        ])
      }
    end

    context '1½' do
      subject { described_class.new('1½').tokenize }

      it {
        expect(subject).to eq([
          [:int, 1, false],
          [:fraction, 1/2r, false]
        ])
      }
    end

    context '1 ½' do
      subject { described_class.new('1 ½').tokenize }

      it {
        expect(subject).to eq([
          [:int, 1, false],
          [:fraction, 1/2r, false]
        ])
      }
    end
  end

  context 'phrases' do
    context '3 / ⅐' do
      subject { described_class.new('3 / ⅐').tokenize }

      let(:tokens) do
        [
          [:int, 3, false],
          [:fraction, 1/7r, false]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '-1 - 2 ½' do
      subject { described_class.new('-1 - 2 ½').tokenize }

      let(:tokens) do
        [
          [:int, 1, true],
          [:int, 2, false],
          [:fraction, 1/2r, false]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '15 quick brown foxes jumped over 3.785 lazy dogs 1½ times' do
      subject { described_class.new('15 quick brown foxes jumped over 3.785 lazy dogs 1½ times').tokenize }

      let(:tokens) do
        [
          [:int, 15, false],
          [:float, 3.785, false],
          [:int, 1, false],
          [:fraction, 1/2r, false]
        ]
      end

      it { is_expected.to eq(tokens) }
    end
  end

  context 'when raising on invalid input' do
    it 'raises if an invalid token is encountered' do
      expect { described_class.new('abc').tokenize(raise: true) }.to raise_error(NumberMuncher::CannotParseError)
    end

    it 'does not raise if no invalid token is encountered' do
      expect { described_class.new('1 1.5 1½').tokenize(raise: true) }.to_not raise_error
    end
  end
end
