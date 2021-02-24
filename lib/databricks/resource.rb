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

    # Add/replace properties for this resource
    #
    # Parameters::
    # * *properties* (Hash<Symbol,Object>): Properties for this resource
    def add_properties(properties)
      # Define getters for properties
      (properties.keys - @properties.keys).each do |property_name|
        if self.respond_to?(property_name)
          raise "Can't define a property named #{property_name} - It's already used."
        else
          define_singleton_method(property_name) { @properties[property_name] }
        end
      end
      @properties.merge!(properties)
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
      resource.add_properties(properties.transform_keys(&:to_sym))
      resource
    end

  end

end
