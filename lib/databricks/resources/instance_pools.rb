module Databricks

  module Resources

    # Provide the Instance Pools API
    # cf. https://docs.databricks.com/dev-tools/api/latest/instance-pools.html
    class InstancePools < Resource

      # List instance pools
      #
      # Result::
      # * Array<InstancePool>: List of instance pools
      def list
        (get_json('instance-pools/list')['instance_pools'] || []).map { |properties| new_resource(:instance_pool, properties) }
      end

      # Get an instance pool based on its instance_pool_id
      #
      # Parameters::
      # * *instance_pool_id* (String): The instance pool id to get
      # Result::
      # * InstancePool: The instance pool
      def get(instance_pool_id)
        new_resource(:instance_pool, get_json('instance-pools/get', { instance_pool_id: instance_pool_id }))
      end

      # Create a new instance pool.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties to create the instance pool
      # Result::
      # * InstancePool: The new instance pool created
      def create(**properties)
        instance_pool = new_resource(:instance_pool, post_json('instance-pools/create', properties))
        instance_pool.add_properties(properties)
        instance_pool
      end

    end

  end

end
