require 'rails_helper'

RSpec.describe TrainingSessionForm::Steps::SlotStep do
  let(:training_session) {create(:training_session, start_time: nil, end_time: nil)}
  let(:session) { {training_session_step: 'slot'} }
  let(:step) {described_class.new(training_session: training_session, session:, **training_session_params)}

  before do
    training_session.assign_attributes(training_session_params)
  end

  describe "validation" do
    context "with valid params" do
      let(:training_session_params) {
        {
          start_time: DateTime.current,
          end_time: DateTime.current + 1
        }
      }

      it "return true on submit" do
        expect(step.submit).to be_truthy
      end

      it "update start_time and end_time" do
        step.submit
        training_session.reload

        expect(training_session.start_time).to eq(training_session_params[:start_time])
        expect(training_session.end_time).to eq(training_session_params[:end_time])
      end
    end

    context "with invalid params" do
      context "start_time is nil" do
        let(:training_session_params) {
          {
            start_time: nil,
            end_time: DateTime.current + 1
          }
        }

        it "render false with a error message" do
          expect(step.submit).to be_falsey
          expect(step.errors.full_messages).to include("Start time #{I18n.t('errors.messages.blank')}")
        end
      end

      context "end_time is nil" do
        let(:training_session_params) {
          {
            start_time: DateTime.current,
            end_time: nil
          }
        }

        it "render false with a error message" do
          step.submit

          expect(step.submit).to be_falsey
          expect(step.errors.full_messages).to include("End time #{I18n.t('errors.messages.blank')}")
        end
      end

      context "when end_time anterior to start_time" do
        let(:start_time) {DateTime.current}

        let(:training_session_params) {
          {
            start_time: start_time,
            end_time: start_time - 1
          }
        }

        it "render false with a error message" do
          step.submit

          expect(step.submit).to be_falsey
          expect(step.errors.full_messages).to include("Start time #{I18n.t('training_sessions.steps.slot.errors.must_be_before_end_time')}")
        end
      end

      context "when end_time equal to start_time" do
        let(:start_time) {DateTime.current}

        let(:training_session_params) {
          {
            start_time: start_time,
            end_time: start_time
          }
        }

        it "render false with a error message" do
          step.submit

          expect(step.submit).to be_falsey
          expect(step.errors.full_messages).to include("Start time #{I18n.t('training_sessions.steps.slot.errors.must_be_before_end_time')}")
        end
      end
    end
  end

  describe "#step" do
    let(:training_session_params) {{}}

    it "return slot as current step" do
      expect(step.step).to eq('slot')
    end
  end

  describe "#next_step" do
    let(:training_session_params) {{}}

    it "return nil as next step" do
      expect(step.next_step).to be_nil
    end
  end

  describe "#previous_step" do
    let(:training_session_params) {{}}

    it "return nil as next step" do
      expect(step.previous_step).to eq('name')
    end
  end
end
