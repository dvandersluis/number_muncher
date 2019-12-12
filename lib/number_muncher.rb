require 'active_support/all'

require 'number_muncher/version'

require 'number_muncher/unicode'
require 'number_muncher/tokenizer'

require 'number_muncher/token/token'
require 'number_muncher/token/int'
require 'number_muncher/token/float'
require 'number_muncher/token/fraction'

require 'number_muncher/parser'

module NumberMuncher
  class CannotParseError < StandardError; end

  def self.parse(str, **opts)
    StringParser.new(str, **opts).parse
    Parser.new(**opts).parse(str)
  end
end
