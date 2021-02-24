require 'databricks/resources/cluster'

describe Databricks::Resources::Cluster do

  before(:each) do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/create').
      with(body: { cluster_name: 'test_cluster_name' }).
      to_return(body: { cluster_id: 'test_cluster_id' }.to_json)
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').clusters.create(cluster_name: 'test_cluster_name')
  end

  it 'edits a cluster' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/edit').
      with(body: { cluster_id: 'test_cluster_id', num_workers: 5 }).
      to_return(body: {}.to_json)
    expect { @api.edit(num_workers: 5) }.not_to raise_error
    expect(@api.num_workers).to eq 5
  end

  it 'deletes a cluster' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/clusters/delete').
      with(body: { cluster_id: 'test_cluster_id' }).
      to_return(body: {}.to_json)
    expect { @api.delete }.not_to raise_error
  end

end
