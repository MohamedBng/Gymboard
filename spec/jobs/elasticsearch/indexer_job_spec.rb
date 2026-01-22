require 'rails_helper'

RSpec.describe Elasticsearch::IndexerJob, type: :job do
  let(:record) { create(:exercise) }
  let(:elasticsearch_proxy) { instance_double('ElasticsearchProxy') }

  context 'update operation' do
    before do
      allow(Exercise).to receive(:find).with(record.id).and_return(record)
      allow(record).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
      allow(elasticsearch_proxy).to receive(:client=)
      allow(elasticsearch_proxy).to receive(:update_document)
    end

    it 'send a update_document request to elasticsearch' do
      described_class.perform_now('update', 'Exercise', record.id)

      expect(elasticsearch_proxy).to have_received(:update_document)
    end
  end

  context 'index operation' do
    before do
      allow(Exercise).to receive(:find).with(record.id).and_return(record)
      allow(record).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
      allow(elasticsearch_proxy).to receive(:client=)
      allow(elasticsearch_proxy).to receive(:index_document)
    end

    it 'send a update_document request to elasticsearch' do
      described_class.perform_now('index', 'Exercise', record.id)

      expect(elasticsearch_proxy).to have_received(:index_document)
    end
  end

  context 'delete operation' do
    let(:client) { instance_double('Elasticsearch::Client') }

    before do
      stub_const('Elasticsearch::IndexerJob::Client', client)
      allow(client).to receive(:delete).with(index: Exercise.index_name, id: record.id)
    end

    it 'send a delete request to elasticsearch' do
      described_class.perform_now('delete', 'Exercise', record.id)

      expect(client).to have_received(:delete).with(
        index: Exercise.index_name,
        id: record.id
      )
    end
  end

  context 'unknown operation' do
    it 'send a update_document request to elasticsearch' do
      expect {
        described_class.perform_now('unknown', 'Exercise', record.id)
      }.to raise_error(ArgumentError, 'Unknown operation: unknown')
    end
  end
end
