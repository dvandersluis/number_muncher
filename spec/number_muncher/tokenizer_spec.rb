RSpec.describe NumberMuncher::Tokenizer do
  context 'invalid' do
    context 'abcd' do
      subject { described_class.new('abcd').call }

      it { is_expected.to be_empty }
    end

    context '1/0' do
      subject { described_class.new('1/0').call }

      it { is_expected.to be_empty }
    end
  end

  context 'integers' do
    context '1' do
      subject { described_class.new('1').call }

      it { is_expected.to eq([[:int, 1]]) }
    end

    context '-1' do
      subject { described_class.new('-1').call }

      it { is_expected.to eq([[:int, -1]]) }
    end

    context '1000' do
      subject { described_class.new('1000').call }

      it { is_expected.to eq([[:int, 1000]]) }
    end

    context '1,000' do
      subject { described_class.new('1,000').call }

      it { is_expected.to eq([[:int, 1000]]) }
    end

    context '-1,000' do
      subject { described_class.new('-1,000').call }

      it { is_expected.to eq([[:int, -1000]]) }
    end
  end

  context 'decimals' do
    context '-.5' do
      subject { described_class.new('-.5').call }

      it { is_expected.to eq([[:float, -1/2r]]) }
    end

    context '-0.5' do
      subject { described_class.new('-0.5').call }

      it { is_expected.to eq([[:float, -1/2r]]) }
    end

    context '1000.005' do
      subject { described_class.new('1000.005').call }

      it { is_expected.to eq([[:float, 1000.005]]) }
    end

    context '-1,000.345' do
      subject { described_class.new('-1,000.345').call }

      it { is_expected.to eq([[:float, -1000.345]]) }
    end
  end

  context 'fractions' do
    context '½' do
      subject { described_class.new('½').call }

      it { is_expected.to eq([[:fraction, 1/2r]]) }
    end

    context '⅐' do
      subject { described_class.new('⅐').call }

      it { is_expected.to eq([[:fraction, 1/7r]]) }
    end

    context '-½' do
      subject { described_class.new('-½').call }

      it { is_expected.to eq([[:fraction, -1/2r]]) }
    end

    context '3/8' do
      subject { described_class.new('3/8').call }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end

    context '-3/8' do
      subject { described_class.new('-3/8').call }

      it { is_expected.to eq([[:fraction, -3/8r]]) }
    end

    context '3 / 8' do
      subject { described_class.new('3 / 8').call }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end

    context '3/08' do
      subject { described_class.new('3/08').call }

      it { is_expected.to eq([[:fraction, 3/8r]]) }
    end

    context '-19/20' do
      subject { described_class.new('-19/20').call }

      it { is_expected.to eq([[:fraction, -19/20r]]) }
    end
  end

  context 'mixed fractions' do
    context '1,000,000 ⅜' do
      subject { described_class.new('1,000,000 ⅜').call }

      it { is_expected.to eq([[:fraction, 8_000_003/8r]]) }
    end

    context '-1½' do
      subject { described_class.new('-1½').call }

      it { is_expected.to eq([[:fraction, -3/2r]]) }
    end

    context '1½' do
      subject { described_class.new('1½').call }

      it { is_expected.to eq([[:fraction, 3/2r]]) }
    end

    context '1 ½' do
      subject { described_class.new('1 ½').call }

      it { is_expected.to eq([[:fraction, 3/2r]]) }
    end

    context '-1 ½' do
      subject { described_class.new('-1 ½').call }

      it { is_expected.to eq([[:fraction, -3/2r]]) }
    end

    context '3⅐' do
      subject { described_class.new('3⅐').call }

      it { is_expected.to eq([[:fraction, 22/7r]]) }
    end

    context '-1 19/20' do
      subject { described_class.new('-1 19/20').call }

      it { is_expected.to eq([[:fraction, -39/20r]]) }
    end

    context '1-3/4' do
      subject { described_class.new('1-3/4').call }

      it { is_expected.to eq([[:fraction, 7/4r]]) }
    end

    context '1-¾' do
      subject { described_class.new('1-¾').call }

      it { is_expected.to eq([[:fraction, 7/4r]]) }
    end

    context 'with new lines' do
      subject { described_class.new("1\n½").call }

      it { is_expected.to eq([[:fraction, 3/2r]]) }
    end
  end

  context 'phrases' do
    context '3 / ⅐' do
      subject { described_class.new('3 / ⅐').call }

      let(:tokens) do
        [
          [:int, 3],
          [:fraction, 1/7r]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '-1 - 2 ½' do
      subject { described_class.new('-1 - 2 ½').call }

      let(:tokens) do
        [
          [:int, -1],
          [:fraction, 5/2r]
        ]
      end

      it { is_expected.to eq(tokens) }
    end

    context '15 quick brown foxes jumped over 3.785 lazy dogs 1½ times' do
      subject { described_class.new('15 quick brown foxes\n jumped over 3.785 lazy dogs 1½ times').call }

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
      expect { described_class.new('abc').call(raise: true) }.to raise_error(NumberMuncher::InvalidNumber)
    end

    it 'does not raise if no invalid token is encountered' do
      expect { described_class.new('1 1.5 1½').call(raise: true) }.to_not raise_error
    end
  end
end
