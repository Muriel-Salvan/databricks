require 'databricks/domain'

module Databricks

  module Domains

    # Provide the DBFS API
    # cf. https://docs.databricks.com/dev-tools/api/latest/dbfs.html
    class Dbfs < Domain

      # List a path
      #
      # Parameters::
      # * *path* (String): Path to be listed
      # Result::
      # * Array<String>: List of DBFS paths
      def list(path)
        @resource.get_json(
          'dbfs/list',
          {
            path: path
          }
        )['files'].map { |file_info| file_info['path'] }
      end

      # Put a new file
      #
      # Parameters::
      # * *path* (String): Path to the file to create
      # * *local_file* (String): Path to the local file to put
      def put(path, local_file)
        @resource.post(
          'dbfs/put',
          {
            path: path,
            contents: File.new(local_file, 'rb'),
            overwrite: true
          }
        )
      end

    end

  end

end
