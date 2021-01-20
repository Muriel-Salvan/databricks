require 'databricks/domains/jobs'

describe Databricks::Domains::Jobs do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').jobs
  end

  it 'lists jobs' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/list').
      to_return(body: {
        jobs: [
          { id: 'test_job_1' },
          { id: 'test_job_2' }
        ]
      }.to_json)
    expect(@api.list).to eq [
      { 'id' => 'test_job_1' },
      { 'id' => 'test_job_2' }
    ]
  end

  it 'creates a new job' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/create').
      with(body: { id: 'test_new_job' }).
      to_return(body: { job_id: '666' }.to_json)
    expect { @api.create(id: 'test_new_job') }.not_to raise_error
  end

end
