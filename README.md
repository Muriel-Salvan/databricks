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
