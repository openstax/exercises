require 'rails_helper'

module Admin
  RSpec.describe ConsoleController, type: :controller do

    let!(:user)  { FactoryGirl.create(:user, :agreed_to_terms) }
    let!(:admin) { FactoryGirl.create(:user, :administrator, :agreed_to_terms) }

    describe 'GET index' do
      context 'for anonymous' do
        it 'redirects to the login page' do
          xhr :get, :index
          expect(response).to redirect_to(controller.openstax_accounts.login_path)
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          expect{ xhr :get, :index }.to raise_error(SecurityTransgression)
        end
      end

      context 'for admins' do
        it 'returns http ok' do
          controller.sign_in admin
          xhr :get, :index
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
