require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject { create(:exercise, title: "blabla") }

  it 'has a valid factory' do
    exercise = build_stubbed(:exercise)
    expect(exercise).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end

  describe 'associations' do
    it { should belong_to(:muscle_group) }
  end

  describe '.search' do
    let(:elasticsearch_proxy) { instance_double('ElasticsearchProxy') }
    let(:search_response) { instance_double('SearchResponse', records: :response_records) }

    before do
      allow(described_class).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
      allow(elasticsearch_proxy).to receive(:search).and_return(search_response)
    end

    context 'when only muscle_group_id is present' do
      it "do a term query" do
        described_class.search(muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          { query: { term: { muscle_group_id: { value: 'chest', boost: 1.0 } } } }
        )
      end
    end

    context 'when muscle_group_id is present and message is blank' do
      it "do a term query" do
        described_class.search(message: ' ', muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          { query: { term: { muscle_group_id: { value: 'chest', boost: 1.0 } } } }
        )
      end
    end

    context 'when muscle_group_id and message are present' do
      it "do a bool query including a must match on title and a filter by term on muscle group" do
        described_class.search(message: 'press', muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          {
            query: {
              bool: {
                must: {
                  match: {
                    title: {
                      query: 'press',
                      fuzziness: 'AUTO'
                    }
                  }
                },
                filter: {
                  term: {
                    muscle_group_id: {
                      value: 'chest',
                      boost: 1.0
                    }
                  }
                }
              }
            }
          }
        )
      end
    end

    context 'when only message is present' do
      it 'do a match query' do
        described_class.search(message: "press")

        expect(elasticsearch_proxy).to have_received(:search).with(
          {
            query: {
              match:  {
                title:  {
                  query: 'press',
                  fuzziness: 'AUTO'
                }
              }
            }
          }
        )
      end
    end

    context 'when message is present but muscle group is blank' do
      it 'do a match query' do
        described_class.search(message: "press", muscle_group_id: " ")

        expect(elasticsearch_proxy).to have_received(:search).with(
          {
            query: {
              match:  {
                title:  {
                  query: 'press',
                  fuzziness: 'AUTO'
                }
              }
            }
          }
        )
      end
    end
  end
end
