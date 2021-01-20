require File.expand_path("#{__dir__}/lib/databricks/version")
require 'time'

Gem::Specification.new do |spec|
  spec.name = 'databricks'
  spec.version = Databricks::VERSION
  spec.date = Time.now.utc.strftime('%F')
  spec.authors = ['Muriel Salvan']
  spec.email = ['muriel@x-aeon.com']
  spec.license = 'BSD-3-Clause'
  spec.summary = 'Rubygem wrapping the Databricks REST API'
  spec.description = 'Access the Databricks API using the simple Ruby way'
  spec.homepage = 'https://github.com/Muriel-Salvan/databricks'
  spec.license = 'BSD-3-Clause'

  spec.files = Dir['{bin,lib}/**/*']
  Dir['bin/**/*'].each do |exec_name|
    spec.executables << File.basename(exec_name)
  end

  # Used to access the the API
  spec.add_dependency 'rest-client', '~> 2.1'

  # Development dependencies (tests, build)
  # Test framework
  spec.add_development_dependency 'rspec', '~> 3.10'
  # Mock web responses from the API
  spec.add_development_dependency 'webmock', '~> 3.11'
  # Automatic semantic releasing
  spec.add_development_dependency 'sem_ver_components', '~> 0.0'
end
