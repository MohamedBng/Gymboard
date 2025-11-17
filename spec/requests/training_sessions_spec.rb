require 'rails_helper'

RSpec.describe 'TrainingSessions', type: :request do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to the sign in page' do
        get training_sessions_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated but has no permissions' do
      let(:user) { create(:user) }
      before { sign_in(user, scope: :user) }

      it 'raises CanCan::AccessDenied' do
        expect {
          get training_sessions_path
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user has read_training_session permission' do
      let(:admin_user) { create(:user, permissions_list: [ 'read_training_session' ]) }
      let!(:other_user) { create(:user) }
      let!(:admin_sessions) { create_list(:training_session, 2, user: admin_user) }
      let!(:other_sessions) { create_list(:training_session, 3, user: other_user) }

      before do
        sign_in(admin_user, scope: :user)
        get training_sessions_path
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns @training_sessions with all sessions' do
        expect(assigns(:training_sessions)).not_to be_nil
        expect(assigns(:training_sessions).count).to eq(5)
        expect(assigns(:training_sessions)).to include(*admin_sessions)
        expect(assigns(:training_sessions)).to include(*other_sessions)
      end

      it 'assigns @q for Ransack' do
        expect(assigns(:q)).to be_a(Ransack::Search)
      end

      it 'orders sessions by start_time descending' do
        sessions = assigns(:training_sessions).to_a
        expect(sessions).to eq(sessions.sort_by(&:start_time).reverse)
      end

      context 'with pagination' do
        before do
          create_list(:training_session, 4, user: admin_user)
          create_list(:training_session, 4, user: other_user)
          get training_sessions_path
        end

        it 'paginates results with 6 per page' do
          expect(assigns(:training_sessions).limit_value).to eq(6)
        end

        it 'returns first page by default' do
          expect(assigns(:training_sessions).current_page).to eq(1)
        end

        context 'when requesting second page' do
          before do
            get training_sessions_path, params: { page: 2 }
          end

          it 'returns second page' do
            expect(assigns(:training_sessions).current_page).to eq(2)
          end
        end
      end

      context 'with Ransack search by muscle_groups' do
        let!(:chest_group) { create(:muscle_group, name: 'Pectoraux') }
        let!(:back_group) { create(:muscle_group, name: 'Dos') }
        let!(:session_with_chest) { create(:training_session, user: admin_user) }
        let!(:session_with_back) { create(:training_session, user: admin_user) }

        before do
          session_with_chest.muscle_groups << chest_group
          session_with_back.muscle_groups << back_group
          get training_sessions_path, params: { q: { muscle_groups_name_cont: 'Pectoraux' } }
        end

        it 'filters sessions by muscle group name' do
          expect(assigns(:training_sessions)).to include(session_with_chest)
          expect(assigns(:training_sessions)).not_to include(session_with_back)
        end
      end
    end

    context 'when user has read_own_training_session permission' do
      let(:user) { create(:user, permissions_list: [ 'read_own_training_session' ]) }
      let!(:other_user) { create(:user) }
      let!(:user_sessions) { create_list(:training_session, 2, user: user) }
      let!(:other_sessions) { create_list(:training_session, 3, user: other_user) }

      before do
        sign_in(user, scope: :user)
        get training_sessions_path
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns @training_sessions with only own sessions' do
        expect(assigns(:training_sessions)).not_to be_nil
        expect(assigns(:training_sessions).count).to eq(2)
        expect(assigns(:training_sessions)).to match_array(user_sessions)
        expect(assigns(:training_sessions)).not_to include(*other_sessions)
      end

      it 'assigns @q for Ransack' do
        expect(assigns(:q)).to be_a(Ransack::Search)
      end

      it 'orders sessions by start_time descending' do
        sessions = assigns(:training_sessions).to_a
        expect(sessions).to eq(sessions.sort_by(&:start_time).reverse)
      end
    end

    context 'when user has both read_training_session and read_own_training_session permissions' do
      let(:admin_user) { create(:user, permissions_list: [ 'read_training_session', 'read_own_training_session' ]) }
      let!(:other_user) { create(:user) }
      let!(:admin_sessions) { create_list(:training_session, 2, user: admin_user) }
      let!(:other_sessions) { create_list(:training_session, 3, user: other_user) }

      before do
        sign_in(admin_user, scope: :user)
        get training_sessions_path
      end

      it 'returns all sessions (read_training_session takes precedence)' do
        expect(assigns(:training_sessions).count).to eq(5)
        expect(assigns(:training_sessions)).to include(*admin_sessions)
        expect(assigns(:training_sessions)).to include(*other_sessions)
      end
    end
  end
end
