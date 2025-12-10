require 'rails_helper'

RSpec.describe TrainingSessionForm::Steps::ExercisesStep, type: :model do
  let(:user) { create(:user) }

  let(:training_session) { create(:training_session, user: user) }
  let(:exercise) { create(:exercise) }
  let(:training_session_exercise) { create(:training_session_exercise, training_session:, exercise:) }
  let(:exercise_set) { create(:exercise_set, training_session_exercise:, weight: nil, reps: nil, rest: nil) }
  let(:session_hash) { { training_session_step: TrainingSessionForm::Steps::ExercisesStep::STEP_NAME } }

  let(:exercises_step) { described_class.new(training_session:, session: session_hash, **training_session_params) }



  describe '#step' do
    let(:training_session_params) {
      {
        "training_session_exercises_attributes" => {}
      }
    }

    it 'returns "exercises"' do
      expect(exercises_step.step).to eq("exercises")
    end
  end

  describe '#next_step' do
    let(:training_session_params) {
      {
        "training_session_exercises_attributes" => {}
      }
    }

    it 'returns "name"' do
      expect(exercises_step.next_step).to eq("name")
    end
  end

  describe '#previous_step' do
    let(:training_session_params) {
      {
        "training_session_exercises_attributes" => {}
      }
    }

    it 'returns nil' do
      expect(exercises_step.previous_step).to be_nil
    end
  end

  describe '#submit' do
    context 'when training_session has no exercises' do
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {}
        }
      }

      it 'returns false' do
        expect(exercises_step.submit).to be false
      end

      it 'adds an error' do
        exercises_step.submit
        expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.no_exercises"))
      end

      it 'does not change the session step' do
        exercises_step.submit
        expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
      end
    end

    context 'when training_session has exercises but no sets' do
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {
            "0" => {
              "id" => training_session_exercise.id,
              "exercise_id" => exercise.id,
              "exercise_sets_attributes" => {}
            }
          }
        }
      }

      it 'returns false' do
        expect(exercises_step.submit).to be false
      end

      it 'adds an error' do
        exercises_step.submit
        expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.no_sets"))
      end

      it 'does not change the session step' do
        exercises_step.submit
        expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
      end
    end

    context 'when training_session has exercises with incomplete sets' do
      context 'when reps is missing' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => nil,
                    "weight" => exercise_set.weight,
                    "rest" => exercise_set.rest
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.incomplete_sets"))
        end
      end

      context 'when weight is missing' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => exercise_set.reps,
                    "weight" => nil,
                    "rest" => exercise_set.rest
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.incomplete_sets"))
        end
      end

      context 'when rest is missing' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => exercise_set.reps,
                    "weight" =>  exercise_set.weight,
                    "rest" => nil
                  }
                }
              }
            }
          }
        }

        before do
          training_session.assign_attributes(training_session_params)
        end

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.incomplete_sets"))
        end
      end
    end

    context 'when training_session has exercises with invalid values' do
      context 'when reps is 0' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => 0,
                    "weight" => 20,
                    "rest" => 60
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.invalid_values"))
        end

        it 'do not update the session' do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
        end
      end

      context 'when reps is negative' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => -1,
                    "weight" => 20,
                    "rest" => 60
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.invalid_values"))
        end

        it 'do not update the session' do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
        end
      end

      context 'when weight is negative' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => 1,
                    "weight" => -20,
                    "rest" => 60
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.invalid_values"))
        end

        it 'do not update the session' do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
        end
      end

      context 'when rest is negative' do
        let(:training_session_params) {
          {
            "training_session_exercises_attributes" => {
              "0" => {
                "id" => training_session_exercise.id,
                "exercise_id" => exercise.id,
                "exercise_sets_attributes" => {
                  "0" => {
                    "id" => exercise_set.id,
                    "reps" => 1,
                    "weight" => 20,
                    "rest" => -60
                  }
                }
              }
            }
          }
        }

        it 'returns false' do
          expect(exercises_step.submit).to be false
        end

        it 'adds an error' do
          exercises_step.submit
          expect(exercises_step.errors[:base]).to include(I18n.t("training_sessions.steps.exercises.errors.invalid_values"))
        end

        it 'do not update the session' do
          expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::STEP_NAME)
        end
      end
    end

    context 'when training_session is valid (has exercises with complete sets)' do
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {
            "0" => {
              "id" => training_session_exercise.id,
              "exercise_id" => exercise.id,
              "exercise_sets_attributes" => {
                "0" => {
                  "id" => exercise_set.id,
                  "reps" => 10,
                  "weight" => 20,
                  "rest" => 60
                }
              }
            }
          }
        }
      }

      it 'returns true' do
        expect(exercises_step.submit).to be true
      end

      it 'has no errors' do
        exercises_step.submit
        expect(exercises_step.errors).to be_empty
      end

      it 'updates the session step to next_step' do
        exercises_step.submit
        expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::NEXT_STEP)
      end
    end

    context 'when training_session has exercises with weight = 0 (bodyweight exercises)' do
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {
            "0" => {
              "id" => training_session_exercise.id,
              "exercise_id" => exercise.id,
              "exercise_sets_attributes" => {
                "0" => {
                  "id" => exercise_set.id,
                  "reps" => 10,
                  "weight" => 0,
                  "rest" => 60
                }
              }
            }
          }
        }
      }

      it 'returns true' do
        expect(exercises_step.submit).to be true
      end

      it 'has no errors' do
        exercises_step.submit
        expect(exercises_step.errors).to be_empty
      end

      it 'updates the session step to next_step' do
        exercises_step.submit
        expect(session_hash[:training_session_step]).to eq(TrainingSessionForm::Steps::ExercisesStep::NEXT_STEP)
      end
    end

    context 'when training_session has exercises with rest = 0 (no rest)' do
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {
            "0" => {
              "id" => training_session_exercise.id,
              "exercise_id" => exercise.id,
              "exercise_sets_attributes" => {
                "0" => {
                  "id" => exercise_set.id,
                  "reps" => 10,
                  "weight" => 15,
                  "rest" => 0
                }
              }
            }
          }
        }
      }

      it 'returns true' do
        expect(exercises_step.submit).to be true
      end

      it 'has no errors' do
        exercises_step.submit
        expect(exercises_step.errors).to be_empty
      end

      it 'update the exercises sets' do
        exercises_step.submit

        exercise_set.reload

        expect(exercise_set.reps).to eq(10)
        expect(exercise_set.weight).to eq(15)
        expect(exercise_set.rest).to eq(0)
      end
    end

    context 'when training_session has multiple exercises with multiple sets' do
      let!(:second_exercise_set) { create(:exercise_set, training_session_exercise:, weight: nil, reps: nil, rest: nil) }
      let!(:second_exercise) { create(:exercise) }
      let!(:second_training_session_exercise) { create(:training_session_exercise, training_session:, exercise: second_exercise) }
      let!(:third_exercise_set) { create(:exercise_set, training_session_exercise: second_training_session_exercise, weight: nil, reps: nil, rest: nil) }
      let(:training_session_params) {
        {
          "training_session_exercises_attributes" => {
            "0" => {
              "id" => training_session_exercise.id,
              "exercise_id" => exercise.id,
              "exercise_sets_attributes" => {
                "0" => {
                  "id" => exercise_set.id,
                  "reps" => 10,
                  "weight" => 15,
                  "rest" => 60
                },
                "1" => {
                  "id" => second_exercise_set.id,
                  "reps" => 8,
                  "weight" => 10,
                  "rest" => 30
                }
              }
            },
            "1" => {
              "id" => second_training_session_exercise.id,
              "exercise_id" => second_exercise.id,
              "exercise_sets_attributes" => {
                "0" => {
                  "id" => third_exercise_set.id,
                  "reps" => 20,
                  "weight" => 20,
                  "rest" => 20
                }
              }
            }
          }
        }
      }

      it 'returns true' do
        expect(exercises_step.submit).to be true
      end

      it 'has no errors' do
        exercises_step.submit
        expect(exercises_step.errors).to be_empty
      end

      it 'updates the session step to next_step' do
        exercises_step.submit
        expect(session_hash[:training_session_step]).to eq("name")
      end

      it 'update all the exercise_sets' do
        exercises_step.submit
        exercise_set.reload
        second_exercise_set.reload
        third_exercise_set.reload

        expect(exercise_set.weight).to eq(15)
        expect(exercise_set.rest).to eq(60)
        expect(exercise_set.reps).to eq(10)

        expect(second_exercise_set.weight).to eq(10)
        expect(second_exercise_set.rest).to eq(30)
        expect(second_exercise_set.reps).to eq(8)

        expect(third_exercise_set.weight).to eq(20)
        expect(third_exercise_set.rest).to eq(20)
        expect(third_exercise_set.reps).to eq(20)
      end
    end
  end
end
