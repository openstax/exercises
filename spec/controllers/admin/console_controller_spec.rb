require 'rails_helper'

module Admin
  RSpec.describe ConsoleController, type: :controller do

    let(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
    let(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

    describe 'GET index' do
      context 'for anonymous' do
        it 'redirects to the login page' do
          get :index, xhr: true
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          expect{ get :index, xhr: true }.to raise_error(SecurityTransgression)
        end
      end

      context 'for admins' do
        it 'returns http ok' do
          controller.sign_in admin
          get :index, xhr: true
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
