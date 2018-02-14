require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  config.before(:suite) { Searchkick.disable_callbacks }

  config.after(:suite) do
    stop_elastic_cluster unless ENV['CI']
  end

  SEARCHABLE_MODELS = [Spree::Product].freeze

  config.around(:each, search: true) do |example|
    start_elastic_cluster unless ENV['CI']

    Searchkick.enable_callbacks
    SEARCHABLE_MODELS.each do |model|
      model.reindex
      model.searchkick_index.refresh
    end

    example.run

    Searchkick.disable_callbacks
    SEARCHABLE_MODELS.each do |model|
      model.searchkick_index.delete
    end
  end
end

def start_elastic_cluster
  ENV['TEST_CLUSTER_PORT'] = '9250'
  ENV['TEST_CLUSTER_NODES'] = '1'
  ENV['TEST_CLUSTER_NAME'] = 'bookstore_test'

  ENV['ELASTICSEARCH_URL'] = "http://localhost:#{ENV['TEST_CLUSTER_PORT']}"

  return if Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.start(timeout: 10)
end

def stop_elastic_cluster
  return unless Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.stop
end
