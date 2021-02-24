module Databricks

  module Resources

    class Cluster < Resource

      # Edit properties of this cluster.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties of this cluster
      def edit(**properties)
        # Make sure we don't change its ID
        properties[:cluster_id] = cluster_id
        post_json('clusters/edit', properties)
        add_properties(properties)
      end

      # Delete a cluster
      def delete
        post_json('clusters/delete', { cluster_id: cluster_id })
      end

    end

  end

end
