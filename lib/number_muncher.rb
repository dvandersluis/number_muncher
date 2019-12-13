require 'active_support/all'

require 'number_muncher/version'

module NumberMuncher
  include ActiveSupport::Configurable

  class InvalidNumber < StandardError; end
  class InvalidParseExpression < StandardError; end

  config_accessor(:thousands_separator, instance_accessor: false) { ',' }
  config_accessor(:decimal_separator, instance_accessor: false) { '.' }

  def self.parse(str)
    Parser.parse(str)
  end

  def self.scan(str)
    Tokenizer.new(str).tokenize
  end
end

require 'number_muncher/unicode'
require 'number_muncher/tokenizer'
require 'number_muncher/to_fraction'

require 'number_muncher/token/token'
require 'number_muncher/token/int'
require 'number_muncher/token/float'
require 'number_muncher/token/fraction'

require 'number_muncher/parser'
