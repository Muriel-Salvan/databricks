module Databricks

  module Resources

    class InstancePool < Resource

      # Edit properties of this instance pool.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties of this cluster
      def edit(**properties)
        # Make sure we don't change its ID
        properties[:instance_pool_id] = instance_pool_id
        post_json('instance-pools/edit', properties)
        add_properties(properties)
      end

      # Delete this instance pool
      def delete
        post_json('instance-pools/delete', { instance_pool_id: instance_pool_id })
      end

    end

  end

end
