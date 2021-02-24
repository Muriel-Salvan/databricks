require 'databricks/resources/instance_pool'

describe Databricks::Resources::InstancePool do

  before(:each) do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/create').
      with(body: { instance_pool_name: 'test_instance_pool_name' }).
      to_return(body: { instance_pool_id: 'test_instance_pool_id' }.to_json)
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').instance_pools.create(instance_pool_name: 'test_instance_pool_name')
  end

  it 'edits an instance pool' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/edit').
      with(body: { instance_pool_id: 'test_instance_pool_id', max_capacity: 5 }).
      to_return(body: {}.to_json)
    expect { @api.edit(max_capacity: 5) }.not_to raise_error
    expect(@api.max_capacity).to eq 5
  end

  it 'deletes an instance_pool' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/delete').
      with(body: { instance_pool_id: 'test_instance_pool_id' }).
      to_return(body: {}.to_json)
    expect { @api.delete }.not_to raise_error
  end

end
