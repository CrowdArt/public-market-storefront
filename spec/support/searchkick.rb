require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  SEARCHABLE_MODELS = [Spree::Product].freeze

  config.before(:suite) do
    Searchkick.disable_callbacks
  end

  config.when_first_matching_example_defined(type: :feature) do
    config.before(:suite) do
      start_elastic_cluster unless elastic_cluster_present?
      SEARCHABLE_MODELS.each(&:reindex)
    end
  end

  config.when_first_matching_example_defined(:search) do
    config.before(:suite) do
      start_elastic_cluster unless elastic_cluster_present?
    end
  end

  config.after(:suite) do
    stop_elastic_cluster unless elastic_cluster_present?
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

def elastic_cluster_present?
  ENV['CI'] || `curl -s localhost:9200`.present?
end

def start_elastic_cluster
  ENV['TEST_CLUSTER_PORT'] = '9250'
  ENV['TEST_CLUSTER_NODES'] = '1'
  ENV['TEST_CLUSTER_NAME'] = 'pm_storefront_test'

  ENV['ELASTICSEARCH_URL'] = "http://localhost:#{ENV['TEST_CLUSTER_PORT']}"

  return if Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.start(timeout: 10, quiet: true)
end

def stop_elastic_cluster
  return unless Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.stop
end
