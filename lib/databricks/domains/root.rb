require 'databricks/domain'

module Databricks

  module Domains

    # API entry point
    # cf. https://docs.databricks.com/dev-tools/api/latest/index.html
    class Root < Domain

      sub_domains %i[
        dbfs
        jobs
      ]

    end

  end

end
