require 'databricks/connector'
require 'databricks/resource'
require 'databricks/resources/root'

module Databricks

  # Get an API connector based on a Databricks URL and API token
  #
  # Parameters::
  # * *host* (String): Host to connect to
  # * *token* (String): Token to be used in th API
  # Result::
  # * Resources::Root: The root resource of the API
  def self.api(host, token)
    Resources::Root.new(Connector.new(host, token))
  end

end
