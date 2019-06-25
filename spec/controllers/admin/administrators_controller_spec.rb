require 'rails_helper'

module Admin
  RSpec.describe AdministratorsController, type: :controller do

    let(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
    let(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

    describe 'GET #index' do
      context 'for anonymous' do
        it 'redirects to the login page' do
          get :index
          expect(response).to redirect_to(controller.openstax_accounts.login_path)
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          expect{ get :index }.to raise_error(SecurityTransgression)
        end
      end

      context 'for admins' do
        it 'returns http ok' do
          controller.sign_in admin
          get :index
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'POST #create' do
      let(:valid_params) { { administrator: { user_id: user.id } } }

      context 'for anonymous' do
        it 'redirects to the login page' do
          expect{ post :create, params: valid_params }.not_to change{ Administrator.count }
          expect(response).to redirect_to(controller.openstax_accounts.login_path)
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          expect{ post :create, params: valid_params }.to raise_error(SecurityTransgression)
        end
      end

      context 'for admins' do
        it 'makes the given user an administrator' do
          controller.sign_in admin
          expect{ post :create, params: valid_params }.to change{ Administrator.count }.by(1)
          expect(response).to redirect_to(admin_administrators_path)
          expect(user.reload.is_administrator?).to eq true
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:valid_params) { { id: admin.administrator.id } }

      context 'for anonymous' do
        it 'redirects to the login page' do
          expect{ delete :destroy, params: valid_params }.not_to change{ Administrator.count }
          expect(response).to redirect_to(controller.openstax_accounts.login_path)
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          expect{ delete :destroy, params: valid_params }.to raise_error(SecurityTransgression)
        end
      end

      context 'for admins' do
        it 'deletes the given administrator' do
          controller.sign_in admin
          expect{ delete :destroy, params: valid_params }.to change{ Administrator.count }.by(-1)
          expect(response).to redirect_to(admin_administrators_path)
          expect(admin.reload.is_administrator?).to eq false
        end
      end
    end

  end
end
