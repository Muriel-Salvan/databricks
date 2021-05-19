module Databricks

  module Resources

    # Provide the Jobs API
    # cf. https://docs.databricks.com/dev-tools/api/latest/jobs.html
    class Jobs < Resource

      # List jobs
      #
      # Result::
      # * Array<Job>: List of jobs information
      def list
        (get_json('jobs/list')['jobs'] || []).map do |properties|
          # The settings property should be merged at root
          new_resource(:job, properties.merge(properties.delete('settings')))
        end
      end

      # Get a job based on its job_id
      #
      # Parameters::
      # * *job_id* (String): The job id to get
      # Result::
      # * Job: The job
      def get(job_id)
        properties = get_json('jobs/get', { job_id: job_id })
        new_resource(:job, properties.merge(properties.delete('settings')))
      end

      # Create a new job.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties to create the job
      # Result::
      # * Job: The new job created
      def create(**properties)
        job = new_resource(:job, post_json('jobs/create', properties))
        job.add_properties(properties)
        job
      end

    end

  end

end
