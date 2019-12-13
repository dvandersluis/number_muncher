RSpec.describe NumberMuncher::Numeric do
  describe '#to_r' do
    subject { described_class.new(value).to_r }

    context 'for a Rational' do
      let(:value) { 3/4r }

      it { is_expected.to eq(3/4r) }
    end

    context 'for an Integer' do
      let(:value) { 17 }

      it { is_expected.to eq(17) }
    end

    context 'for a Float' do
      let(:value) { 3.1415 }

      it { is_expected.to eq(3.1415) }
    end

    context 'for a String' do
      let(:value) { '9 3/4' }

      it { is_expected.to eq(39/4r) }
    end

    context 'for an invalid String' do
      let(:value) { 'abc' }

      it { expect { subject }.to raise_error(NumberMuncher::InvalidNumber) }
    end
  end

  describe '#round' do
    it { expect(described_class.new(1).round).to eq(1) }
    it { expect(described_class.new(1).round(1)).to eq(1) }
    it { expect(described_class.new(-1).round(1)).to eq(-1) }
    it { expect(described_class.new(2).round(10)).to eq(0) }
    it { expect(described_class.new(3/8r).round(1/2r)).to eq(1/2r) }
    it { expect(described_class.new(0.7).round(1/8r)).to eq(3/4r) }
    it { expect(described_class.new(0.7).round('1/8')).to eq(3/4r) }

    it 'raises an error for invalid input' do
      expect { described_class.new(0.7).round('abcd') }.to raise_error(NumberMuncher::InvalidNumber)
    end
  end
end
