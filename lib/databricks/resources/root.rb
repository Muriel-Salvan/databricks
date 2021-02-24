require 'databricks/resource'

module Databricks

  module Resources

    # API entry point
    # cf. https://docs.databricks.com/dev-tools/api/latest/index.html
    class Root < Resource

      sub_resources %i[
        clusters
        dbfs
        jobs
      ]

    end

  end

end
