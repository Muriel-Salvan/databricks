module Databricks

  module Resources

    class Job < Resource

      # Reset properties of this job.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): New job's properties
      def reset(**properties)
        # Make sure we don't change its ID
        post_json(
          'jobs/reset',
          {
            job_id: job_id,
            new_settings: properties
          }
        )
        add_properties(properties.merge(job_id: job_id), replace: true)
      end

      # Delete this job
      def delete
        post_json('jobs/delete', { job_id: job_id })
      end

    end

  end

end
