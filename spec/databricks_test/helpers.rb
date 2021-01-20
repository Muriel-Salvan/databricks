require 'databricks'
require 'webmock/rspec'

module DatabricksTest

  # Define some helpers needed for the test cases
  module Helpers

  end

end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # As some errors might include HTTP content, better to put more length into error messages
    c.max_formatted_output_length = 1_000_000
  end
end
