require 'databricks/resources/root'

describe Databricks::Resources::Root do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token')
  end

  it 'gives access to the dbfs sub-resource' do
    expect(@api.dbfs.class).to eq Databricks::Resources::Dbfs
  end

  it 'gives access to the jobs sub-resource' do
    expect(@api.jobs.class).to eq Databricks::Resources::Jobs
  end

  it 'gives access to the clusters sub-resource' do
    expect(@api.clusters.class).to eq Databricks::Resources::Clusters
  end

  it 'gives access to the instance_pools sub-resource' do
    expect(@api.instance_pools.class).to eq Databricks::Resources::InstancePools
  end

end
