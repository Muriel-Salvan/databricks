require 'databricks/resources/clusters'

describe Databricks::Resources::Clusters do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').clusters
  end

  it 'lists clusters' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/list').
      to_return(body: {
        clusters: [
          { cluster_id: 'test_cluster_1' },
          { cluster_id: 'test_cluster_2' }
        ]
      }.to_json)
    expect(@api.list.map(&:cluster_id).sort).to eq %w[test_cluster_1 test_cluster_2].sort
  end

  it 'creates a new cluster' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/create').
      with(body: { cluster_name: 'test_new_cluster' }).
      to_return(body: { cluster_id: '666' }.to_json)
    expect(@api.create(cluster_name: 'test_new_cluster').cluster_id).to eq '666'
  end

  it 'gets an existing cluster' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/get').
      with(body: { cluster_id: 'test_cluster_id' }).
      to_return(body: {
        cluster_id: 'test_cluster_id',
        cluster_name: 'test_cluster_name'
      }.to_json)
    cluster = @api.get('test_cluster_id')
    expect(cluster.cluster_id).to eq 'test_cluster_id'
    expect(cluster.cluster_name).to eq 'test_cluster_name'
  end

end
