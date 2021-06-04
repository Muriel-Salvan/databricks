[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

# databricks - Use the Databricks API the Ruby way

## Description

This Rubygem gives you access to the [Databricks REST API](https://docs.databricks.com/dev-tools/api/latest/index.html) using the simple Ruby way.

## Requirements

`databricks` only needs [Ruby](https://www.ruby-lang.org/) to run.

## Install

Via gem

``` bash
$ gem install databricks
```

If using `bundler`, add this in your `Gemfile`:

``` ruby
gem 'databricks'
```

## Usage

The API is articulated around resources hierarchy mapping the official Databricks API documentation.
It is accessed using the `Databricks#api` method, giving both the host to connect to and an API token.

Example to list the root path of the DBFS storage of an instance:
```ruby
require 'databricks'

databricks = Databricks.api('https://my_databricks_instance.my_domain.com', '123456789abcdef123456789abcdef')
databricks.dbfs.list('/').each do |file|
  puts "Found DBFS file: #{file.path}"
end
```

Here is a simple code snippet showing the most common examples of the API.

```ruby
require 'databricks'

databricks = Databricks.api('https://my_databricks_instance.my_domain.com', '123456789abcdef123456789abcdef')

# ===== DBFS

databricks.dbfs.list('/').each do |file|
  puts "Found DBFS file: #{file.path} (size: #{file.file_size})"
  puts 'It is a directory' if file.is_dir
end

databricks.dbfs.put('/dbfs_path/to/file.txt', 'local_file.txt')
puts databricks.dbfs.read('/dbfs_path/to/file.txt')['data']
databricks.dbfs.delete('/dbfs_path/to/file.txt')

# ===== Clusters

databricks.clusters.each do |cluster|
  puts "Found cluster named #{cluster.cluster_name} with id #{cluster.cluster_id} using Spark #{cluster.spark_version} in state #{cluster.state}"
end
cluster = databricks.clusters.get('my-cluster-id')

new_cluster = databricks.clusters.create(
  cluster_name: 'my-test-cluster',
  spark_version: '7.1.x-scala2.12',
  node_type_id: 'Standard_DS3_v2',
  driver_node_type_id: 'Standard_DS3_v2',
  num_workers: 1,
  creator_user_name: 'me@my_domain.com'
)
new_cluster.edit(num_workers: 2)
new_cluster.delete

# ===== Jobs

databricks.jobs.list.each do |job|
  puts "Found job #{job.name} with id #{job.job_id}"
end

new_job = databricks.jobs.create(
  name: 'My new job',
  new_cluster: {
    spark_version: '7.3.x-scala2.12',
    node_type_id: 'r3.xlarge'
    num_workers: 10
  },
  libraries: [
    {
      jar: 'dbfs:/my-jar.jar'
    }
  ],
  timeout_seconds: 3600,
  spark_jar_task: {
    main_class_name: 'com.databricks.ComputeModels'
  }
)
puts "Job created with id #{new_job.job_id}"
new_job.reset(
  new_cluster: {
    spark_version: '7.3.x-scala2.12',
    node_type_id: 'r3.xlarge',
    num_workers: 10
  },
  libraries: [
    {
      jar: 'dbfs:/my-jar.jar'
    }
  ],
  timeout_seconds: 3600,
  spark_jar_task: {
    main_class_name: 'com.databricks.ComputeModels'
  }
)
new_job.delete
# Get a job from its job_id
found_job = databricks.jobs.get(666)

# ===== Instance pools

databricks.instance_pools.each do |instance_pool|
  puts "Found instance pool named #{instance_pool.instance_pool_name} with id #{instance_pool.instance_pool_id} and max capacity #{instance_pool.max_capacity}"
end
instance_pool = databricks.instance_pools.get('my-instance-pool-id')

new_instance_pool = databricks.instance_pools.create(
  instance_pool_name: 'my-pool',
  node_type_id: 'i3.xlarge',
  min_idle_instances: 10
)
new_instance_pool.edit(min_idle_instances: 5)
new_instance_pool.delete
# Get an instance pool from its instance_pool_id
found_pool = databricks.instance_pools.get('my-pool-id')

```

## Change log

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Testing

Automated tests are done using rspec.

To execute them, first install development dependencies:

```bash
bundle install
```

Then execute rspec

```bash
bundle exec rspec
```

## Contributing

Any contribution is welcome:
* Fork the github project and create pull requests.
* Report bugs by creating tickets.
* Suggest improvements and new features by creating tickets.

## Credits

- [Muriel Salvan](https://x-aeon.com/muriel)

## License

The BSD License. Please see [License File](LICENSE.md) for more information.
