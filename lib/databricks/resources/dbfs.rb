module Databricks

  module Resources

    # Provide the DBFS API
    # cf. https://docs.databricks.com/dev-tools/api/latest/dbfs.html
    class Dbfs < Resource

      # List a path
      #
      # Parameters::
      # * *path* (String): Path to be listed
      # Result::
      # * Array<String>: List of DBFS paths
      def list(path)
        (get_json('dbfs/list', { path: path })['files'] || []).map { |properties| new_resource(:file, properties) }
      end

      # Put a new file
      #
      # Parameters::
      # * *path* (String): Path to the file to create
      # * *local_file* (String): Path to the local file to put
      def put(path, local_file)
        post(
          'dbfs/put',
          {
            path: path,
            contents: ::File.new(local_file, 'rb'),
            overwrite: true
          }
        )
      end

      # Delete a path
      #
      # Parameters::
      # * *path* (String): Path to delete
      # * *recursive* (Boolean): Do we delete recursively? [default: false]
      def delete(path, recursive: false)
        post_json(
          'dbfs/delete',
          {
            path: path,
            recursive: recursive
          }
        )
      end

    end

  end

end
