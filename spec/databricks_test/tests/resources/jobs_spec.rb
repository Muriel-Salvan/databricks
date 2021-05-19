require 'databricks/resources/jobs'

describe Databricks::Resources::Jobs do

  before(:each) do
    @api = Databricks.api('https://my_databricks_instance.my_domain.com', 'my_test_token').jobs
  end

  it 'lists jobs' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/list').
      to_return(body: {
        jobs: [
          {
            job_id: 1,
            settings: {
              name: 'Test job 1'
            }
          },
          {
            job_id: 2,
            settings: {
              name: 'Test job 2'
            }
          }
        ]
      }.to_json)
    expect(@api.list.map(&:job_id).sort).to eq [1, 2].sort
    expect(@api.list.map(&:name).sort).to eq ['Test job 1', 'Test job 2'].sort
  end

  it 'lists jobs with properties deep-symbolization' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/list').
      to_return(body: {
        jobs: [
          {
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
            }
          }
        ]
      }.to_json)
    expect(@api.list.first.new_cluster).to eq(
      spark_version: '7.3.x-scala2.12',
      node_type_id: 'r3.xlarge',
      aws_attributes: {
        availability: 'ON_DEMAND'
      },
      num_workers: 10
    )
  end

  it 'creates a new job' do
    stub_request(:post, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/create').
      with(body: { name: 'test_new_job' }).
      to_return(body: { job_id: 666 }.to_json)
    expect(@api.create(name: 'test_new_job').job_id).to eq 666
  end

  it 'gets an existing job' do
    stub_request(:get, 'https://my_databricks_instance.my_domain.com/api/2.0/jobs/get').
      with(body: { job_id: 666 }).
      to_return(body: {
        job_id: 666,
        settings: {
          name: 'Test job'
        },
        created_time: 1457570074236
      }.to_json)
    job = @api.get(666)
    expect(job.job_id).to eq 666
    expect(job.name).to eq 'Test job'
    expect(job.created_time).to eq 1457570074236
  end

end
