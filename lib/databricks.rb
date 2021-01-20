require 'databricks/domains/root'
require 'databricks/resource'

module Databricks

  # Get an API connector based on a Databricks URL and API token
  #
  # Parameters::
  # * *host* (String): Host to connect to
  # * *token* (String): Token to be used in th API
  # Result::
  # * Domains::Root: The root domain of the API
  def self.api(host, token)
    Domains::Root.new(Resource.new(host, token))
  end

end
