require 'rails_helper'

RSpec.describe IncrementExerciseUsedCountJob, type: :job do
  let(:bench_press) { create(:exercise, title: 'bench press', used_count: 5) }
  let(:lateral_raises) { create(:exercise, title: 'lateral raises', used_count: 2) }
  let(:training_session) { create(:training_session) }

  let!(:lateral_raises_training_session_exercise) {
    create(:training_session_exercise, training_session: training_session, exercise: lateral_raises)
  }

  let!(:bench_press_training_session_exercise) {
    create(:training_session_exercise, training_session: training_session, exercise: bench_press)
  }

  it "update used_count for each training session exercises" do
    described_class.perform_now(training_session.id)

    bench_press.reload
    lateral_raises.reload

    expect(bench_press.used_count).to eq(6)
    expect(lateral_raises.used_count).to eq(3)
  end

  it "enqueue a Elasticsearch::Exercise::BulkUpdateUsedCountJob for each exercises" do
    described_class.perform_now(training_session.id)

    expect {
      described_class.perform_now(training_session.id)
    }.to have_enqueued_job(Elasticsearch::Exercise::BulkUpdateUsedCountJob).with(training_session.exercise_ids)
  end
end
