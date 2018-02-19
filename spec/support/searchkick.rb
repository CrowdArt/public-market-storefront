require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  SEARCHABLE_MODELS = [Spree::Product].freeze

  config.before(:suite) do
    start_elastic_cluster unless ENV['CI']
    SEARCHABLE_MODELS.each(&:reindex)
    Searchkick.disable_callbacks
  end

  config.after(:suite) do
    stop_elastic_cluster unless ENV['CI']
  end

  config.around(:each, search: true) do |example|
    Searchkick.enable_callbacks

    SEARCHABLE_MODELS.each do |model|
      model.reindex
      model.searchkick_index.refresh
    end

    example.run

    Searchkick.disable_callbacks
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
