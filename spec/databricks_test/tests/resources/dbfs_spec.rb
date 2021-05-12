require 'base64'
require 'tempfile'
require 'databricks/resources/dbfs'

describe Databricks::Resources::Dbfs do

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
    expect(@api.list('/my_test/path').map(&:path).sort).to eq %w[test_file_1 test_file_2].sort
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

  it 'deletes paths' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/delete').
      with(body: { path: '/my_test/path', recursive: false }).
      to_return(body: {}.to_json)
    expect { @api.delete('/my_test/path') }.not_to raise_error
  end

  it 'deletes paths recursively' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/delete').
      with(body: { path: '/my_test/path', recursive: true }).
      to_return(body: {}.to_json)
    expect { @api.delete('/my_test/path', recursive: true) }.not_to raise_error
  end

  it 'reads a file' do
    mocked_content = 'This is a test content'
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/read').
      with(body: {
        path: '/my_test/path',
        offset: 0,
        length: 524_288
      }).
      to_return(body: {
        bytes_read: mocked_content.size,
        data: Base64.encode64(mocked_content)
      }.to_json)
    expect(@api.read('/my_test/path')).to eq(
      'bytes_read' => mocked_content.size,
      'data' => mocked_content
    )
  end

end
