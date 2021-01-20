require 'databricks/domains/root'

describe Databricks::Domains::Root do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token')
  end

  it 'gives access to the dbfs sub-domain' do
    expect(@api.dbfs).not_to eq nil
  end

  it 'gives access to the jobs sub-domain' do
    expect(@api.dbfs).not_to eq nil
  end

end
