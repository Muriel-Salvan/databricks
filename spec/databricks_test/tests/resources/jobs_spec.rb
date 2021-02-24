require 'databricks/resources/jobs'

describe Databricks::Resources::Jobs do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').jobs
  end

  it 'lists jobs' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/list').
      to_return(body: {
        jobs: [
          { job_id: 'test_job_1' },
          { job_id: 'test_job_2' }
        ]
      }.to_json)
    expect(@api.list.map(&:job_id).sort).to eq %w[test_job_1 test_job_2].sort
  end

  it 'creates a new job' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/create').
      with(body: { job_name: 'test_new_job' }).
      to_return(body: { job_id: '666' }.to_json)
    expect(@api.create(job_name: 'test_new_job').job_id).to eq '666'
  end

end
