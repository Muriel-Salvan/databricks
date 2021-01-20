module Databricks

  # Encapsulate a part of the API for better organization
  class Domain

    # Declare sub-domain accessors in the current domain.
    # This will make sure the current domain has methods named after the sub-domain identifiers that will instantiate the corresponding domains at will.
    #
    # Parameters::
    # * *domains* (Array<Symbol>): Domains to instantiate
    def self.sub_domains(*domains)
      domains.flatten.each do |domain|
        self.define_method(domain) do
          sub_domain(domain)
        end
      end
    end

    # Instantiate a sub-domain.
    # Keep a cache of it.
    #
    # Parameters::
    # * *domain* (Symbol): Sub-domain identifier.
    # Result::
    # * Domain: Corresponding sub-domain
    def sub_domain(domain)
      unless @sub_domains.key?(domain)
        require "#{__dir__}/domains/#{domain}.rb"
        @sub_domains[domain] = Domains.const_get(domain.to_s.split('_').collect(&:capitalize).join.to_sym).new(@resource)
      end
      @sub_domains[domain]
    end

    # Constructor
    #
    # Parameters::
    # * *resource* (Resource): Resource handling API calls
    def initialize(resource)
      @resource = resource
      # Keep a map of sub-domains instantiated, per domain identifier.
      # Hash< Symbol, Domain >
      @sub_domains = {}
    end

  end

end
