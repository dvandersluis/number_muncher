RSpec::Matchers.define(:parse_to) do |expected|
  match do |actual|
    @options ||= {}
    @result = described_class.new(**@options).parse(actual)
    expect(@result).to eq(expected)
  end

  chain :with_options do |**options|
    @options = options
  end

  failure_message do |actual|
    "expected that #{actual} would be a multiple of #{expected}, but was #{@result}"
  end
end
