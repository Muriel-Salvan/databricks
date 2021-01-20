require 'json'
require 'rest-client'

module Databricks

  # Underlying resource making API calls
  class Resource

    # Constructor
    #
    # Parameters::
    # * *host* (String): Host to connect to
    # * *token* (String): Token to be used in th API
    def initialize(host, token)
      @host = host
      @token = token
    end

    # Issue a GET request to the API with JSON payload
    #
    # Parameters::
    # * *api_path* (String): API path to query
    # * *json_payload* (Object): JSON payload to include in the query [default = {}]
    # Result::
    # * Object: JSON result
    def get_json(api_path, json_payload = {})
      JSON.parse(
        RestClient::Request.execute(
          method: :get,
          url: "#{@host}/api/2.0/#{api_path}",
          payload: json_payload.to_json,
          headers: {
            Authorization: "Bearer #{@token}",
            'Content-Type': 'application/json'
          }
        ).body
      )
    end

    # Issue a POST request to the API with JSON payload
    #
    # Parameters::
    # * *api_path* (String): API path to query
    # * *json_payload* (Object): JSON payload to include in the query [default = {}]
    # Result::
    # * Object: JSON result
    def post_json(api_path, json_payload = {})
      JSON.parse(
        RestClient::Request.execute(
          method: :post,
          url: "#{@host}/api/2.0/#{api_path}",
          payload: json_payload.to_json,
          headers: {
            Authorization: "Bearer #{@token}",
            'Content-Type': 'application/json'
          }
        ).body
      )
    end

    # Issue a POST request to the API with multipart form data payload
    #
    # Parameters::
    # * *api_path* (String): API path to query
    # * *form_payload* (Hash): Form payload to include in the query [default = {}]
    def post(api_path, form_payload = {})
      RestClient::Request.execute(
        method: :post,
        url: "#{@host}/api/2.0/#{api_path}",
        payload: form_payload.merge(multipart: true),
        headers: {
          Authorization: "Bearer #{@token}"
        }
      )
    end

  end

end
