require 'databricks/resources/instance_pools'

describe Databricks::Resources::InstancePools do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').instance_pools
  end

  it 'lists instance pools' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/list').
      to_return(body: {
        instance_pools: [
          { instance_pool_id: 'test_instance_pool_1' },
          { instance_pool_id: 'test_instance_pool_2' }
        ]
      }.to_json)
    expect(@api.list.map(&:instance_pool_id).sort).to eq %w[test_instance_pool_1 test_instance_pool_2].sort
  end

  it 'creates a new instance pool' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/create').
      with(body: { instance_pool_name: 'test_new_instance_pool' }).
      to_return(body: { instance_pool_id: '666' }.to_json)
    expect(@api.create(instance_pool_name: 'test_new_instance_pool').instance_pool_id).to eq '666'
  end

  it 'gets an existing instance pool' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/instance-pools/get').
      with(body: { instance_pool_id: 'test_instance_pool_id' }).
      to_return(body: {
        instance_pool_id: 'test_instance_pool_id',
        instance_pool_name: 'test_instance_pool_name'
      }.to_json)
    instance_pool = @api.get('test_instance_pool_id')
    expect(instance_pool.instance_pool_id).to eq 'test_instance_pool_id'
    expect(instance_pool.instance_pool_name).to eq 'test_instance_pool_name'
  end

end
