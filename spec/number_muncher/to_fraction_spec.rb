RSpec.describe NumberMuncher::ToFraction do
  let(:unicode) { true }
  let(:factor) { nil }

  let(:options) { { unicode: unicode, factor: factor }.compact }

  subject { described_class.new(**options) }

  it 'handles nil' do
    expect(subject.call(nil)).to eq('')
  end

  context 'with unicode fractions' do
    let(:unicode) { true }

    it { expect(subject.call(0)).to eq('0') }
    it { expect(subject.call(5.4375)).to eq('5 7/16') }
    it { expect(subject.call(0.00001)).to eq('0') }
    it { expect(subject.call(0.5)).to eq('½') }
    it { expect(subject.call(1.5)).to eq('1½') }
    it { expect(subject.call(2.8)).to eq('2⅘') }
    it { expect(subject.call(2)).to eq('2') }
    it { expect(subject.call(-2)).to eq('-2') }
    it { expect(subject.call(0.3)).to eq('3/10') }
    it { expect(subject.call(0.3333)).to eq('⅓') }
    it { expect(subject.call(-0.3333)).to eq('-⅓') }
    it { expect(subject.call(1/1r)).to eq('1') }
    it { expect(subject.call(2/1r)).to eq('2') }
  end

  context 'without unicode fractions' do
    let(:unicode) { false }

    it { expect(subject.call(0.5)).to eq('1/2') }
    it { expect(subject.call(1.5)).to eq('1 1/2') }
    it { expect(subject.call(-0.3333)).to eq('-1/3') }
  end

  context 'when a different rationalization factor is set' do
    let(:factor) { 0.1 }

    it { expect(subject.call(0.3)).to eq('⅓') }
    it { expect(subject.call(3.3)).to eq('3⅓') }
    it { expect(subject.call(0.3333)).to eq('⅓') }
  end

  context 'when rounding' do
    it { expect(subject.call(1/7r, round_to: 1/7r)).to eq('⅐') }
    it { expect(subject.call(2/7r, round_to: 1/64r)).to eq('9/32') }
    it { expect(subject.call(1/7r, round_to: 1/4r)).to eq('¼') }
    it { expect(subject.call(3, round_to: 1/4r)).to eq('3') }
    it { expect(subject.call(3/5r, round_to: 1)).to eq('1') }
    it { expect(subject.call(1/2r, round_to: 1/7r)).to eq('4/7') }
    it { expect(subject.call(6.789, round_to: 1/2r)).to eq('7') }
    it { expect(subject.call(6.789, round_to: 10)).to eq('10') }
    it { expect(subject.call(17, round_to: 7.5)).to eq('15') }

    it 'raises an error if given round_to: 0' do
      expect { subject.call(1.23, round_to: 0) }.to raise_error(NumberMuncher::IllegalRoundValue)
    end
  end
end
