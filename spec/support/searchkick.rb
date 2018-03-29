require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  SEARCHABLE_MODELS = [Spree::Product].freeze

  config.before(:suite) do
    start_elastic_cluster unless elastic_cluster_present?
    SEARCHABLE_MODELS.each(&:reindex)
    Searchkick.disable_callbacks
  end

  config.after(:suite) do
    stop_elastic_cluster unless elastic_cluster_present?
  end

  config.around(:each, search: true) do |example|
    Searchkick.enable_callbacks

    SEARCHABLE_MODELS.each do |model|
      model.after_save do
        model.reindex
        model.searchkick_index.refresh
      end

      model.reindex
      model.searchkick_index.refresh
    end

    example.run

    SEARCHABLE_MODELS.each do |model|
      model.searchkick_index.delete
    end

    Searchkick.disable_callbacks
  end
end

def elastic_cluster_present?
  ENV['CI'] || `curl -s localhost:9200`.present?
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
