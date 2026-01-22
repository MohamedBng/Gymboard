module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit lambda { Elasticsearch::IndexerJob.perform_later("index", self.class.to_s, self.id) }, on: :create
    after_commit lambda { Elasticsearch::IndexerJob.perform_later("update", self.class.to_s, self.id) }, on: :update
    after_commit lambda { Elasticsearch::IndexerJob.perform_later("delete", self.class.to_s, self.id) }, on: :destroy

    after_touch lambda { Elasticsearch::IndexerJob.perform_later("update", self.class.to_s, self.id) }
  end
end
