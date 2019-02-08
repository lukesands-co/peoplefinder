if Rails.env.production? or Rails.env.staging?
  require 'faraday_middleware/aws_signers_v4'

  transport = Elasticsearch::Transport::Transport::HTTP::Faraday.new(
    hosts: [{host: ENV['ELASTICSEARCH_HOST'], port: ENV['ELASTICSEARCH_PORT']}]
  ) do |faraday|
    faraday.request :aws_signers_v4,
      credentials: Aws::Credentials.new(ENV['ELASTICSEARCH_KEY'], ENV['ELASTICSEARCH_SECRET']),
      service_name: 'es',
      region: ENV['ELASTICSEARCH_REGION']
    faraday.adapter  Faraday.default_adapter
  end

  Elasticsearch::Model.client = Elasticsearch::Client.new(transport: transport, transport_options: { headers: { accept:   'application/json', content_type: 'application/json' }})

end

if Rails.env.development?
  Elasticsearch::Model.client = Elasticsearch::Client.new(trace: true, log: true, transport_options: { headers: { accept:   'application/json', content_type: 'application/json' }})
end
