describe 'The entry point of the API' do

  it 'returns a Databricks API entry point' do
    api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token')
    expect(api).not_to eq nil
  end

  it 'uses the correct URLs and tokens in queries' do
    api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token')
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/dbfs/list').
      with(
        body: { path: '/' },
        headers: {
          'Authorization' => 'Bearer my_test_token',
          'Content-Type'=>'application/json'
        }
      ).
      to_return(
        body: {
          files: [
            { path: 'test_file_1' },
            { path: 'test_file_2' }
          ]
        }.to_json
      )
    expect(api.dbfs.list('/')).to eq %w[test_file_1 test_file_2]
  end

end
