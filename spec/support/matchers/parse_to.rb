RSpec::Matchers.define(:parse_to) do |expected|
  match do |actual|
    @result = described_class.parse(actual)
    expect(@result).to eq(expected)
  end

  chain :with_options do |**options|
    options.each do |key, val|
      allow(NumberMuncher.config).to receive(key).and_return(val)
    end
  end

  failure_message do |actual|
    "expected that #{actual} would be a multiple of #{expected}, but was #{@result}"
  end
end
