require 'zeitwerk'

module NumberMuncher
  module Loader
    def self.instance
      @instance ||= begin
        called_from = caller_locations(1, 1).first.path
        Zeitwerk::Registry.loader_for_gem(called_from).tap do |loader| # rubocop:disable Style/SymbolProc
          loader.enable_reloading

          # loader.logger = method(:puts)
        end
      end
    end
  end
end
