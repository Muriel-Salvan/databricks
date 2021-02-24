module Databricks

  module Resources

    # Provide the Clusters API
    # cf. https://docs.databricks.com/dev-tools/api/latest/clusters.html
    class Clusters < Resource

      # List clusters
      #
      # Result::
      # * Array<Hash>: List of clusters information
      def list
        (get_json('clusters/list')['clusters'] || []).map { |properties| new_resource(:cluster, properties) }
      end

      # Get a cluster based on its cluster_id
      #
      # Result::
      # * Cluster: The cluster
      def get(cluster_id)
        new_resource(:cluster, get_json('clusters/get', { cluster_id: cluster_id }))
      end

      # Create a new cluster.
      #
      # Parameters::
      # * *properties* (Hash<Symbol,Object>): Properties to create the cluster
      def create(**properties)
        cluster = new_resource(:cluster, post_json('clusters/create', properties))
        cluster.add_properties(properties)
        cluster
      end

    end

  end

end
