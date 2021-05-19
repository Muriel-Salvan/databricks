require 'forwardable'

module Databricks

  # Encapsulate a resource identified in the API.
  # A resource can have some properties, directly accessible, and also gives access to eventual sub-resources to get a hierarchical organization of the API.
  class Resource

    extend Forwardable

    # Delegate the API low-level methods to the @connector object
    def_delegators :@connector, *%i[
      get_json
      post
      post_json
    ]

    # Get an accessor on all properties of this resource
    # Hash< Symbol, Object >
    attr_reader :properties

    # Declare sub-resources accessors.
    # This will make sure this resource has methods named after the sub-resources identifiers.
    #
    # Parameters::
    # * *resource_names* (Array<Symbol>): Resource names to instantiate
    def self.sub_resources(*resource_names)
      resource_names.flatten.each do |resource_name|
        self.define_method(resource_name) do
          sub_resource(resource_name)
        end
      end
    end

    # Constructor
    #
    # Parameters::
    # * *connector* (Connector): Connector handling API calls
    def initialize(connector)
      @connector = connector
      # Keep a map of sub-resources instantiated, per resource name.
      # Hash< Symbol, Resource >
      @sub_resources = {}
      # Properties linked to this resource
      # Hash< Symbol, Object >
      @properties = {}
    end

    # Add/replace properties for this resource.
    # Properties will be deep-symbolized.
    #
    # Parameters::
    # * *properties* (Hash<Symbol or String,Object>): Properties for this resource
    # * *replace* (Boolean): Should we replace properties instead of merging them? [default: false]
    def add_properties(properties, replace: false)
      symbolized_properties = deep_symbolize(properties)
      # Define getters for properties
      (symbolized_properties.keys - @properties.keys).each do |property_name|
        if self.respond_to?(property_name)
          raise "Can't define a property named #{property_name} - It's already used."
        else
          define_singleton_method(property_name) { @properties[property_name] }
        end
      end
      if replace
        @properties = symbolized_properties
      else
        @properties.merge!(symbolized_properties)
      end
    end

    # Return a simple string representation of this resource
    #
    # Result::
    # * String: Default representation
    def inspect
      "#<#{self.class.name.split('::').last} - #{@properties}>"
    end

    # Instantiate a sub-resource.
    # Keep a cache of it.
    #
    # Parameters::
    # * *resource_name* (Symbol): Resource name.
    # Result::
    # * Resource: Corresponding sub-resource
    def sub_resource(resource_name)
      @sub_resources[resource_name] = new_resource(resource_name) unless @sub_resources.key?(resource_name)
      @sub_resources[resource_name]
    end

    # Instantiate a new resource, with optional properties
    #
    # Parameters::
    # * *resource_name* (Symbol): The resource's name.
    # * *properties* (Hash<Symbol or String,Object>): This resource's initial properties [default = {}]
    # Result::
    # * Resource: The corresponding resource
    def new_resource(resource_name, properties = {})
      require "#{__dir__}/resources/#{resource_name}.rb"
      resource = Resources.const_get(resource_name.to_s.split('_').collect(&:capitalize).join.to_sym).new(@connector)
      resource.add_properties(properties)
      resource
    end

    private

    # Deep-symbolize a JSON object
    #
    # Parameters::
    # * *json* (Object): The JSON object
    # Result::
    # * Object: Symbolized JSON object
    def deep_symbolize(json)
      case json
      when Hash
        Hash[json.map do |k, v|
          [
            k.is_a?(String) ? k.to_sym : k,
            deep_symbolize(v)
          ]
        end]
      when Array
        json.map { |e| deep_symbolize(e) }
      else
        json
      end
    end

  end

end
