require 'databricks/resources/root'

describe Databricks::Resources::Root do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token')
  end

  it 'gives access to the dbfs sub-resource' do
    expect(@api.dbfs).not_to eq nil
  end

  it 'gives access to the jobs sub-resource' do
    expect(@api.jobs).not_to eq nil
  end

  it 'gives access to the clusters sub-resource' do
    expect(@api.clusters).not_to eq nil
  end

end
