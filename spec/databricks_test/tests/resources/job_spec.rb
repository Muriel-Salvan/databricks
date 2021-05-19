require 'databricks/resources/job'

describe Databricks::Resources::Job do

  before(:each) do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/get').
      with(body: { job_id: 666 }).
      to_return(body: {
        job_id: 666,
        settings: {
          name: 'Test job',
          new_cluster: {
            spark_version: '7.3.x-scala2.12',
            node_type_id: 'r3.xlarge',
            aws_attributes: {
              availability: 'ON_DEMAND'
            },
            num_workers: 10
          }
        },
        created_time: 1457570074236
      }.to_json)
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').jobs.get(666)
  end

  it 'resets a job' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/reset').
      with(body: {
        job_id: 666,
        new_settings: {
          num_workers: 5
        }
      }).
      to_return(body: {}.to_json)
    expect { @api.reset(num_workers: 5) }.not_to raise_error
    expect(@api.num_workers).to eq 5
  end

  it 'deletes a job' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/delete').
      with(body: { job_id: 666 }).
      to_return(body: {}.to_json)
    expect { @api.delete }.not_to raise_error
  end

end
