require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject { create(:exercise, title: "bench press") }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).scoped_to(:user_id) }

    context 'when exercise is set to public' do
      let(:muscle_group) { create(:muscle_group) }
      let(:muscle) { create(:muscle) }

      it "raise an error if primary_muscle is not present" do
        exercise = build(:exercise, title: "bench press", primary_muscle: nil, muscle_group: muscle_group, public: true)
        expect(exercise).to_not be_valid
      end

      it "raise an error if muscle_group is not present" do
        exercise = build(:exercise, title: "bench press", muscle_group: nil, primary_muscle: muscle, public: true)
        expect(exercise).to_not be_valid
      end

      it "raise an error if title is not present" do
        exercise = build(:exercise, title: nil, muscle_group: muscle_group, primary_muscle: muscle, public: false)
        expect(exercise).to_not be_valid
      end

      it "is valid if title, muscle_group and primary_muscle are present" do
        exercise = build(:exercise, title: "bench press", muscle_group: muscle_group, primary_muscle: muscle, public: true)
        expect(exercise).to be_valid
      end
    end
  end

  describe '.soft_delete!' do
    let(:exercise) { build(:exercise, delete_at: nil) }
    it "set delete_at to current date time" do
      exercise.soft_delete!

      expect(exercise.delete_at).to be_within(1.second).of(DateTime.now)
    end
  end

  describe '.restore_soft_delete!' do
    let(:exercise) { build(:exercise, delete_at: nil) }
    it "set delete_at to nil" do
      exercise.restore_soft_delete!

      expect(exercise.delete_at).to be_nil
    end
  end

  describe '.search' do
    let(:elasticsearch_proxy) { instance_double('ElasticsearchProxy') }
    let(:search_response) { instance_double('SearchResponse', records: :response_records) }

    before do
      allow(described_class).to receive(:__elasticsearch__).and_return(elasticsearch_proxy)
      allow(elasticsearch_proxy).to receive(:search).and_return(search_response)
    end

    context 'when any params is present' do
      it "does a match all query" do
        described_class.search

        expect(elasticsearch_proxy).to have_received(:search).with(
          ({ query: { term: { public: true } } })
        )
      end
    end

    context 'when only muscle_group_id is present' do
      it "do a term query" do
        described_class.search(muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          ({ query: { bool: { filter: [ { term: { "public" => { value: "true" } } }, { term: { "muscle_group_id" => { value: "chest" } } } ] } } })
        )
      end
    end

    context 'when muscle_group_id is present and message is blank' do
      it "do a term query" do
        described_class.search(message: ' ', muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          {
            query: {
              bool: {
                filter: [
                  {
                    term: {
                      "public" => {
                        value: "true"
                      }
                    }
                  },
                  {
                    term: {
                      "muscle_group_id" => {
                        value: "chest"
                      }
                    }
                  }
                ]
              }
            }
          }
        )
      end
    end

    context 'when muscle_group_id and message are present' do
      it "do a bool query including a must match on title and a filter by term on muscle group and public" do
        described_class.search(message: 'press', muscle_group_id: 'chest')

        expect(elasticsearch_proxy).to have_received(:search).with(
          {
            query: {
              bool: {
                must: [ {
                  match: {
                    "title" => {
                      query: 'press',
                      fuzziness: 'AUTO'
                    }
                  }
                } ],
                filter: [
                  {
                    term: {
                      "public" => {
                        value: 'true'
                      }
                    }
                  },
                  {
                    term: {
                      "muscle_group_id" => {
                        value: 'chest'
                      }
                    }
                  }
                ]
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
          ({
            query: {
              bool: {
                must: [
                  {
                    match: {
                      "title" => {
                        query: "press",
                        fuzziness: "AUTO"
                      }
                    }
                  }
                ],
                filter: [
                  {
                    term: {
                      "public" => {
                        value: 'true'
                      }
                    }
                  }
                ]
              }
            }
          })
        )
      end
    end

    context 'when message is present but muscle group is blank' do
      it 'do a match query' do
        described_class.search(message: "press", muscle_group_id: " ")

        expect(elasticsearch_proxy).to have_received(:search).with(
          ({
            query: {
              bool: {
                must: [
                  {
                    match: {
                      "title" => {
                        query: "press",
                        fuzziness: "AUTO"
                      }
                    }
                  }
                ],
                filter: [
                  {
                    term: {
                      "public" => {
                        value: 'true'
                      }
                    }
                  }
                ]
              }
            }
          })
        )
      end
    end

    context 'when scope is present' do
      context 'when scope == "current_user"' do
        it "do a term query with only current_user_id" do
          described_class.search(current_user_id: 1, scope: 'current_user')

          expect(elasticsearch_proxy).to have_received(:search).with(
            ({ query: { bool: { filter: [ { term: { "user_id" => { value: 1 } } } ] } } })
          )
        end

        context 'when message is present' do
          it "do a bool query with message and user_id" do
            described_class.search(message: 'press', current_user_id: 1, scope: 'current_user')

            expect(elasticsearch_proxy).to have_received(:search).with(
              {
                query: {
                  bool: {
                    must: [ {
                      match: {
                        "title" => {
                          query: 'press',
                          fuzziness: 'AUTO'
                        }
                      }
                    } ],
                    filter: [ {
                      term: {
                        "user_id" => {
                          value: 1
                        }
                      }
                    } ]
                  }
                }
              }
            )
          end
        end

        context 'when muscle_group_id is present' do
          it "do a bool query with muscle_group_id and current_user_id " do
            described_class.search(muscle_group_id: 12, current_user_id: 1, scope: 'current_user')

            expect(elasticsearch_proxy).to have_received(:search).with(
              {
                query: {
                  bool: {
                    filter: [
                      {
                        term: {
                          "user_id" => {
                            value: 1
                          }
                        }
                      },
                      {
                        term: {
                          "muscle_group_id" => {
                            value: 12
                          }
                        }
                      }
                    ]
                  }
                }
              }
            )
          end
        end

        context 'when message and muscle_group_id are present' do
          it "do a bool query with message and current_user_id" do
            described_class.search(message: 'press', muscle_group_id: 12, current_user_id: 1, scope: 'current_user')

            expect(elasticsearch_proxy).to have_received(:search).with(
              {
                query: {
                  bool: {
                    must: [ {
                      match: {
                        "title" => {
                          query: 'press',
                          fuzziness: 'AUTO'
                        }
                      }
                    } ],
                    filter: [
                      {
                        term: {
                          "user_id" => {
                            value: 1
                          }
                        }
                      },
                      {
                        term: {
                          "muscle_group_id" => {
                            value: 12
                          }
                        }
                      }
                    ]
                  }
                }
              }
            )
          end
        end
      end

      context 'when scope == "verified"' do
        it "do a exists query with the field verified" do
          described_class.search(scope: 'verified')

          expect(elasticsearch_proxy).to have_received(:search).with(
            ({
              query: {
                bool: {
                  filter: [
                    {
                      exists: {
                        field: 'verified_at'
                      }
                    },
                    {
                      term: {
                        "public" => {
                          value: 'true'
                        }
                      }
                    }
                  ]
                }
              }
            })
          )
        end
      end
    end
  end

  describe 'elastic search indexer callbacks' do
    context 'when creating an exercise' do
      it "enqueue a Elasticsearch::IndexerJob with the good arguments" do
        expect {
          create(:exercise)
        }.to have_enqueued_job(Elasticsearch::IndexerJob)
        .with('index', 'Exercise', kind_of(Integer))
        .on_queue('elasticsearch')
      end
    end

    context 'when updating an exercise' do
      let(:exercise) { create(:exercise) }

      it "enqueue a Elasticsearch::IndexerJob with the good arguments" do
        expect {
          exercise.update!(title: "new name")
        }.to have_enqueued_job(Elasticsearch::IndexerJob)
        .with('update', 'Exercise', exercise.id)
        .on_queue('elasticsearch')
      end
    end

    context 'when deleting an exercise' do
      let(:exercise) { create(:exercise) }

      it "enqueue a Elasticsearch::IndexerJob with the good arguments" do
        expect {
          exercise.destroy!
        }.to have_enqueued_job(Elasticsearch::IndexerJob)
        .with('delete', 'Exercise', exercise.id)
        .on_queue('elasticsearch')
      end
    end
  end

  describe '.complete?' do
    context 'when exercise is complete' do
      let(:complete_exercise) { create(:exercise, :with_secondary_muscles) }

      it "return true" do
        expect(complete_exercise.complete?).to be_truthy
      end
    end

    context 'when muscle_group is nil' do
      let(:incomplete_exercise) { create(:exercise, muscle_group_id: nil) }

      it "return false" do
        expect(incomplete_exercise.complete?).to be_falsey
      end
    end

    context 'when there is no secondary muscles' do
      let(:incomplete_exercise) { create(:exercise, secondary_muscles: []) }

      it "return false" do
        expect(incomplete_exercise.complete?).to be_falsey
      end
    end
  end
end
