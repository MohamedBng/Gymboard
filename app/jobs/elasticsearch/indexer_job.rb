class Elasticsearch::IndexerJob < ApplicationJob
  queue_as :elasticsearch

  Client = Elasticsearch::Client.new(host: ENV.fetch("ELASTICSEARCH_CLIENT_URL", "http://localhost:9200"))

  def perform(operation, klass, record_id)
    case operation.to_s
    when /create|update/
      record = klass.constantize.find(record_id)
      record.__elasticsearch__.client = Client
      record.__elasticsearch__.__send__ "#{operation}_document"
    when /delete/
      Client.delete(index: klass.constantize.index_name, id: record_id)
    else
      raise ArgumentError, "Unknown operation: #{operation}"
    end
  end
end
