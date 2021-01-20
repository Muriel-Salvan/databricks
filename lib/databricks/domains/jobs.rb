require 'databricks/domain'

module Databricks

  module Domains

    # Provide the Jobs API
    # cf. https://docs.databricks.com/dev-tools/api/latest/jobs.html
    class Jobs < Domain

      # List a path
      #
      # Result::
      # * Array<Hash>: List of jobs information
      def list
        @resource.get_json('jobs/list')['jobs']
      end

      # Create a new job
      #
      # Parameters::
      # * *settings* (Hash<Symbol,Object>): Settings to create the job
      def create(**settings)
        @resource.post_json('jobs/create', settings)
      end

    end

  end

end
