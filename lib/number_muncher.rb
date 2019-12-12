require 'number_muncher/version'

require 'number_muncher/string_parser'

module NumberMuncher
  class CannotParseError < StandardError; end

  def self.parse(str, **opts)
    StringParser.new(str, **opts).parse
  end
end
