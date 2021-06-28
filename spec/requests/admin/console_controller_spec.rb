require 'rails_helper'

RSpec.describe Admin::ConsoleController, type: :request do
  let(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  context 'for anonymous' do
    context 'GET /admin' do
      it 'returns 403 Forbidden' do
        get admin_url, xhr: true
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin' do
      it 'raises SecurityTransgression' do
        expect { get admin_url, xhr: true }.to raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin' do
      it 'returns http ok' do
        get admin_url, xhr: true
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
