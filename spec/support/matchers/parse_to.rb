RSpec::Matchers.define(:parse_to) do |expected|
  match do |actual|
    @options ||= {}
    expect(described_class.new(actual, **@options).parse).to eq(expected)
  end

  chain :with_options do |**options|
    @options = options
  end
end
