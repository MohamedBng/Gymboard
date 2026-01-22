Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV.fetch("ELASTICSEARCH_CLIENT_URL", "http://localhost:9200"))
