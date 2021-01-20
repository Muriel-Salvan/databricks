require 'tempfile'
require 'databricks/domains/dbfs'

describe Databricks::Domains::Dbfs do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').dbfs
  end

  it 'lists paths' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/list').
      with(body: { path: '/my_test/path' }).
      to_return(body: {
        files: [
          { path: 'test_file_1' },
          { path: 'test_file_2' }
        ]
      }.to_json)
    expect(@api.list('/my_test/path')).to eq %w[test_file_1 test_file_2]
  end

  it 'puts a new file' do
    Tempfile.open('databricks_test') do |temp_file|
      temp_file.write('Databricks test file content')
      stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/put').
        with do |request|
          expect(Hash[
            request.
              body.
              split("\n").
              map { |line| line =~ /------RubyFormBoundary/ || line.strip.empty? ? nil : line.strip }.
              compact.
              each_slice(2).
              to_a
          ]).to eq(
            'Content-Disposition: form-data; name="path"' => '/my_test/path',
            "Content-Disposition: form-data; name=\"contents\"; filename=\"#{File.basename(temp_file.path)}\"" => 'Content-Type: text/plain',
            'Content-Disposition: form-data; name="overwrite"' => 'true'
          )
        end.
        to_return(body: '')
      expect { @api.put('/my_test/path', temp_file.path) }.not_to raise_error
    end
  end

end
