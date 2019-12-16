require 'active_support/all'

# Setup zeitwerk
require 'number_muncher/loader'
NumberMuncher::Loader.instance.setup

module NumberMuncher
  include ActiveSupport::Configurable

  class InvalidNumber < StandardError; end
  class InvalidParseExpression < StandardError; end
  class IllegalRoundValue < StandardError; end

  config_accessor(:thousands_separator, instance_accessor: false) { ',' }
  config_accessor(:decimal_separator, instance_accessor: false) { '.' }

  def self.parse(str)
    Numeric.new(str)
  end

  def self.scan(str)
    Tokenizer.new(str).tokenize
  end

  def self.to_fraction(value, round_to: nil, **opts)
    parse(value).round(round_to).to_fraction(**opts)
  end
end
