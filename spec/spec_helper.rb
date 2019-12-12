require 'bundler/setup'
require 'number_muncher'
require 'pry'

root = Pathname.new(File.dirname(__dir__))

Dir[root.join('spec/support/matchers/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
    mocks.yield_receiver_to_any_instance_implementation_blocks = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching(:focus)
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.order = :random
  Kernel.srand(config.seed)
end
