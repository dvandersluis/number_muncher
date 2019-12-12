RSpec.describe NumberMuncher::Tokenizer do
  context 'invalid' do
    context 'abcd' do
      subject { described_class.new('abcd').tokenize }

      it { is_expected.to be_empty }
    end

    context '1/0' do
      subject { described_class.new('1/0').tokenize }

      it { is_expected.to be_empty }
    end
  end

  context 'integers' do
    context '1' do
      subject { described_class.new('1').tokenize }

      it { is_expected.to eq([[:int, 1]]) }
    end

    context '-1' do
      subject { described_class.new('-1').tokenize }

      it { is_expected.to eq([[:int, -1]]) }
    end

    context '1000' do
      subject { described_class.new('1000').tokenize }

      it { is_expected.to eq([[:int, 1000]]) }
    end

    context '1,000' do
      subject { described_class.new('1,000').tokenize }

      it { is_expected.to eq([[:int, 1000]]) }
    end

    context '-1,000' do
      subject { described_class.new('-1,000').tokenize }

      it { is_expected.to eq([[:int, -1000]]) }
    end
  end

  context 'decimals' do
    context '-.5' do
      subject { described_class.new('-.5').tokenize }

      it { is_expected.to eq([[:float, -1/2r]]) }
    end

    context '-0.5' do
      subject { described_class.new('-0.5').tokenize }

      it { is_expected.to eq([[:float, -1/2r]]) }
    end

    context '1000.005' do
      subject { described_class.new('1000.005').tokenize }

      it { is_expected.to eq([[:float, 1000.005]]) }
    end

    context '-1,000.345' do
      subject { described_class.new('-1,000.345').tokenize }

      it { is_expected.to eq([[:float, -1000.345]]) }
    end
  end

  context 'fractions' do
    context '½' do
      subject { described_class.new('½').tokenize }

      it { is_expected.to eq([[:fraction, 1/2r]]) }
    end

    context '⅐' do
      subject { described_class.new('⅐').tokenize }

      it { is_expected.to eq([[:fraction, 1/7r]]) }
    end

    context '-½' do
      subject { described_class.new('-½').tokenize }

      it { is_expected.to eq([[:fraction, -1/2r]]) }
    end

    context '3/8' do
      subject { described_class.new('3/8').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end

    context '-3/8' do
      subject { described_class.new('-3/8').tokenize }

      it { is_expected.to eq([[:fraction, -3/8r]]) }
    end

    context '3 / 8' do
      subject { described_class.new('3 / 8').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end

    context '3/08' do
      subject { described_class.new('3/08').tokenize }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end
  end

  context 'mixed fractions' do
    context '1,000,000 ⅜' do
      subject { described_class.new('1,000,000 ⅜').tokenize }

      it { is_expected.to eq([[:fraction, 8_000_003/8r]]) }
    end

    context '-1½' do
      subject { described_class.new('-1½').tokenize }

      it { is_expected.to eq([[:fraction, -3/2r]]) }
    end

    context '1½' do
      subject { described_class.new('1½').tokenize }

      it { is_expected.to eq([[:fraction, 3/2r]]) }
    end

    context '1 ½' do
      subject { described_class.new('1 ½').tokenize }

      it { is_expected.to eq([[:fraction, 3/2r]]) }
    end

    context '-1 ½' do
      subject { described_class.new('-1 ½').tokenize }

      it { is_expected.to eq([[:fraction, -3/2r]]) }
    end

    context '3⅐' do
      subject { described_class.new('3⅐').tokenize }

      it { is_expected.to eq([[:fraction, 22/7r]]) }
    end
  end

  context 'phrases' do
    context '3 / ⅐' do
      subject { described_class.new('3 / ⅐').tokenize }

      let(:tokens) do
        [
          [:int, 3],
          [:fraction, 1/7r]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '-1 - 2 ½' do
      subject { described_class.new('-1 - 2 ½').tokenize }

      let(:tokens) do
        [
          [:int, -1],
          [:fraction, 5/2r]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '15 quick brown foxes jumped over 3.785 lazy dogs 1½ times' do
      subject { described_class.new('15 quick brown foxes jumped over 3.785 lazy dogs 1½ times').tokenize }

      let(:tokens) do
        [
          [:int, 15],
          [:float, 3.785],
          [:fraction, 3/2r]
        ]
      end

      it { is_expected.to eq(tokens) }
    end
  end

  context 'when raising on invalid input' do
    it 'raises if an invalid token is encountered' do
      expect { described_class.new('abc').tokenize(raise: true) }.to raise_error(NumberMuncher::InvalidNumber)
    end

    it 'does not raise if no invalid token is encountered' do
      expect { described_class.new('1 1.5 1½').tokenize(raise: true) }.to_not raise_error
    end
  end
end
