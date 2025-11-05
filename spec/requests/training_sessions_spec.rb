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
