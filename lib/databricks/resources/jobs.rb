module Databricks

  module Resources

    # Provide the Jobs API
    # cf. https://docs.databricks.com/dev-tools/api/latest/jobs.html
    class Jobs < Resource

      # List jobs
      #
      # Result::
      # * Array<Hash>: List of jobs information
      def list
        (get_json('jobs/list')['jobs'] || []).map { |properties| new_resource(:job, properties) }
      end

      # Create a new job.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties to create the job
      def create(**properties)
        job = new_resource(:job, post_json('jobs/create', properties))
        job.add_properties(properties)
        job
      end

    end

  end

end
