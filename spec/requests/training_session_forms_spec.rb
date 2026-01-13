require 'rails_helper'

RSpec.describe TrainingSessionFormsController, type: :request do
  describe 'GET #new' do
    context "when user has permission create_own_training_session" do
      let(:user) { create(:user, permissions_list: [ 'create_own_training_session' ]) }

      before do
        sign_in(user, scope: :user)
        get new_training_session_form_path
      end

      it "render a status 2OO" do
        expect(response).to have_http_status(200)
      end

      it "initialize the form with the current user and session" do
        expect(assigns(:form)).to be_a(TrainingSessionForm)
        expect(assigns(:form).training_session).to be_a(TrainingSession)
        expect(assigns(:form).session[:training_session_step]).to eq(TrainingSessionForm::FIRST_STEP)
        expect(assigns(:form).user).to eq(user)
      end
    end

    context "when user has permission create_training_session" do
      let(:user) { create(:user, permissions_list: [ 'create_training_session' ]) }

      before do
        sign_in(user, scope: :user)
        get new_training_session_form_path
      end

      it "render a status 2OO" do
        expect(response).to have_http_status(200)
      end
    end

    context "when user hasn't permissions" do
      let(:user) { create(:user) }

      before do
        sign_in(user, scope: :user)
      end

      it "raise a CanCan::AccessDenied error" do
        expect { get new_training_session_form_path }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user, permissions_list: [ 'update_own_training_session' ]) }
    let!(:original_name) { 'original name' }
    let!(:training_session) { create(:training_session, name: original_name, user: user) }
    let!(:muscle_group) { create(:muscle_group) }
    let!(:params) {
      {
        training_session: {
          name: "training session",
          start_time: DateTime.current,
          end_time: DateTime.current + 1
        }
      }
    }

    context 'when last step' do
      let!(:session_hash) { { training_session_step: TrainingSessionForm::LAST_STEP } }

      before do
        sign_in(user, scope: :user)
        allow_any_instance_of(TrainingSessionFormsController).to receive(:session).and_return(session_hash)
      end

      context 'with valid params' do
        let(:params) {
          {
            training_session: {
              name: "new name"
            }
          }
        }

        before do
          patch training_session_form_path(training_session, params: params)
          training_session.reload
        end

        it "update the training session status on submit" do
          expect(training_session.status).to eq("active")
        end

        it "redirect to the training_sessions_path" do
          expect(response).to redirect_to(training_sessions_path)
        end
      end

      context 'with invalid params' do
        let(:params) {
          {
            training_session: {
              nama: nil
            }
          }
        }

        before do
          patch training_session_form_path(training_session, params: params)
          training_session.reload
        end

        it "do not update the training session status" do
          expect(training_session.status).to eq("draft")
        end

        it "render the new view with a 422 code" do
          expect(response).to render_template(:new)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'exercices step' do
      let(:exercise) { create(:exercise) }
      let(:training_session_exercise) { create(:training_session_exercise, training_session:, exercise:) }
      let(:exercise_set) { create(:exercise_set, weight: nil, reps: nil, rest: nil, training_session_exercise:) }
      let(:session_hash) { { training_session_step: 'exercises' } }

      before do
        sign_in(user, scope: :user)
        allow_any_instance_of(TrainingSessionFormsController).to receive(:session).and_return(session_hash)
      end

      context 'when params are valid' do
        let(:params) {
          {
            "training_session" => {
              "training_session_exercises_attributes" => {
                "0" => {
                  "id" => training_session_exercise.id,
                  "exercise_id" => exercise.id,
                  "exercise_sets_attributes" => {
                    "0" => {
                      "id" => exercise_set.id,
                      "reps" => 10,
                      "human_weight" => 20,
                      "rest" => 60
                    }
                  }
                }
              }
            }
          }
        }

        before do
          patch training_session_form_path(training_session, params: params)
        end

        it "update session training_session_step with the next step name" do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::NEXT_STEP)
        end

        it "update the training_session sets" do
          exercise_set.reload

          expect(exercise_set.weight).to eq(20000)
          expect(exercise_set.human_weight).to eq(20.0)
          expect(exercise_set.reps).to eq(10)
          expect(exercise_set.rest).to eq(60)
        end

        it "redirect to new_training_session_form_path" do
          expect(response).to redirect_to(new_training_session_form_path)
        end
      end

      context 'when params are invalid' do
        let(:params) {
          {
            "training_session" => {
              "training_session_exercises_attributes" => {
                "0" => {
                  "id" => training_session_exercise.id,
                  "exercise_id" => exercise.id,
                  "exercise_sets_attributes" => {
                    "0" => {
                      "id" => exercise_set.id,
                      "reps" => 10,
                      "human_weight" => nil,
                      "rest" => 60
                    }
                  }
                }
              }
            }
          }
        }

        before do
          patch training_session_form_path(training_session, params: params)
        end

        it "do not update session training_session_step with the next step name" do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
        end

        it "do not update the training_session sets" do
          exercise_set.reload

          expect(exercise_set.weight).to be_nil
          expect(exercise_set.reps).to be_nil
          expect(exercise_set.rest).to be_nil
        end

        it "render new templete with a 422 code" do
          expect(response).to render_template(:new)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'slot step' do
      let!(:session_hash) { { training_session_step: 'slot' } }

      before do
        sign_in(user, scope: :user)
        allow_any_instance_of(TrainingSessionFormsController).to receive(:session).and_return(session_hash)
      end

      context 'with valid params' do
        let(:new_start_time) { Time.current }
        let(:new_end_time) { new_start_time + 1 }
        let(:params) {
          {
            training_session: {
              start_time: new_start_time,
              end_time: new_end_time
            }
          }
        }

        before do
          patch training_session_form_path(training_session), params: params
        end

        it 'return a 302 status' do
          expect(response).to have_http_status(302)
        end

        it "render training_sessions index view" do
          expect(response).to redirect_to(new_training_session_form_path)
        end

        it 'update start_time and end_time' do
          training_session.reload

          expect(training_session.start_time).to be_within(1.second).of(new_start_time)
          expect(training_session.end_time).to be_within(1.second).of(new_end_time)
        end
      end

      context "with unpermitted params" do
        let!(:updated_start_time) { Time.current }

        let(:params) {
          {
            training_session: {
              name: "updated name",
              start_time: updated_start_time,
              end_time: updated_start_time + 1
            }
          }
        }

        before do
          patch training_session_form_path(training_session), params: params
        end

        it "ignores certain params" do
          training_session.reload

          expect(training_session.name).to eq("original name")
          expect(training_session.start_time).to be_within(1.second).of(updated_start_time)
        end

        it "render training_sessions new view" do
          expect(response).to redirect_to(new_training_session_form_path)
        end
      end


      context "with invalid params" do
        context "start_time is nil" do
          let(:original_start_time) { Time.now.prev_day }
          let(:original_end_time) { Time.now.prev_day + 1 }
          let(:user) { create(:user, permissions_list: [ 'update_own_training_session' ]) }
          let(:training_session) {  create(:training_session,
                                            start_time: original_start_time,
                                            end_time: original_end_time,
                                            user: user
                                          )}


          let(:params) {
            {
              training_session: {
                start_time: nil,
                end_time: original_end_time + 5
              }
            }
          }

          before do
            patch training_session_form_path(training_session), params: params
          end

          it "render new_training_session_form" do
            expect(response).to render_template(:new)
          end

          it "render a 422 error" do
            expect(response).to have_http_status(422)
          end

          it "do not update the object" do
            expect(training_session.start_time).to eq(original_start_time)
            expect(training_session.end_time).to eq(original_end_time)
          end
        end
      end
    end

    context 'name step' do
      let!(:session_hash) { { training_session_step: 'name' } }

      before do
        sign_in(user, scope: :user)
        allow_any_instance_of(TrainingSessionFormsController).to receive(:session).and_return(session_hash)
      end

      context 'with valid params' do
        let(:new_name) { "Patrick" }

        let(:params) {
          {
            training_session: {
              name: new_name
            }
          }
        }

        before do
          patch training_session_form_path(training_session), params: params
        end

        it 'return a 302 status' do
          expect(response).to have_http_status(302)
        end

        it "render training_sessions index view" do
          expect(response).to redirect_to(training_sessions_path)
        end

        it 'update start_time and end_time' do
          training_session.reload

          expect(training_session.name).to eq(new_name)
        end
      end

      context "with invalid params" do
        context "name is nil" do
          let(:start_time) { Time.current - 1 }
          let(:user) { create(:user, permissions_list: [ 'update_own_training_session' ]) }

          let(:params) {
            {
              training_session: {
                name: nil,
                start_time: start_time
              }
            }
          }

          before do
            patch training_session_form_path(training_session, params: params)
          end

          it "render new_training_session_form" do
            expect(response).to render_template(:new)
          end

          it "render a 422 error" do
            expect(response).to have_http_status(422)
          end

          it "do not update the object" do
            expect(training_session.start_time).to_not eq(start_time)
            expect(training_session.name).to eq(original_name)
          end
        end
      end
    end

    context 'muscle groups step' do
      let!(:session_hash) { { training_session_step: TrainingSessionForm::Steps::MuscleGroupsStep::STEP_NAME } }

      before do
        sign_in(user, scope: :user)
        allow_any_instance_of(TrainingSessionFormsController).to receive(:session).and_return(session_hash)
      end

      context 'with valid params' do
        let!(:params) {
          {
            training_session: {
              muscle_group_ids: [ muscle_group.id ]
            }
          }
        }

        it 'return a 302 status' do
          patch training_session_form_path(training_session, params: params)

          expect(response).to have_http_status(302)
        end

        it "render training_sessions index view" do
          patch training_session_form_path(training_session, params: params)

          expect(response).to redirect_to(new_training_session_form_path)
        end

        it "update the training_session_muscle_groups" do
          expect {
            patch training_session_form_path(training_session, params: params)
          }.to change { training_session.training_session_muscle_groups.count }.by(1)
        end
      end

      context "with invalid params" do
        let(:start_time) { Time.current }
        let(:user) { create(:user, permissions_list: [ 'update_own_training_session' ]) }

        let!(:params) {
          {
            "training_session" => {
              "muscle_group_ids" => []
            }
          }
        }

        before do
          patch training_session_form_path(training_session), params: params
        end

        it "render new_training_session_form" do
          expect(response).to render_template(:new)
        end

        it "render a 422 error" do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
