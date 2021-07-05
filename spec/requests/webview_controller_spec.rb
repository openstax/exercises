require 'rails_helper'

RSpec.describe WebviewController, type: :request do
  let!(:contract)       do
    FinePrint::Contract.create!(
      name: 'general_terms_of_use',
      title: 'General Terms of Use',
      content: Faker::Lorem.paragraphs,
      version: 10
    )
  end
  let(:new_user)        { FactoryBot.create(:user) }
  let(:registered_user) { FactoryBot.create(:user, :agreed_to_terms) }

  context 'as anonymous' do
    context 'GET /' do
      it 'renders the home page' do
        get root_url
        expect(response).to have_http_status(:ok)
      end
    end

    context 'GET /dashboard' do
      it 'redirects to login' do
        get dashboard_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end
  end

  context 'as a deleted user' do
    before do
      sign_in registered_user
      registered_user.delete
    end

    context 'GET /' do
      it 'signs the user out and renders the home page' do
        get root_url
        expect(@controller.current_user).to eq AnonymousUser.instance
        expect(response).to redirect_to(root_url)
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'GET /dashboard' do
      it 'signs the user out and redirects to the home page' do
        get dashboard_url
        expect(@controller.current_user).to eq AnonymousUser.instance
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context 'as a new user' do
    before { sign_in new_user }

    context 'GET /' do
      it 'renders the home page' do
        get root_url
        expect(response).to have_http_status(:ok)
      end
    end

    context 'GET /dashboard' do
      it 'requires agreement to contracts' do
        get dashboard_url
        expect(response).to redirect_to(fine_print.new_contract_signature_url(contract))
      end
    end
  end

  context 'as an existing user' do
    before { sign_in registered_user }

    context 'GET /' do
      it 'renders the home page' do
        get root_url
        expect(response).to have_http_status(:ok)
      end
    end

    context 'GET /dashboard' do
      it 'returns 200 OK' do
        get dashboard_url
        expect(response).to have_http_status(:ok)
      end

      it 'renders a script tag with the boostrap data' do
        get dashboard_url
        data = ::JSON.parse(css_select('script#exercises-boostrap-data').first.inner_html)
        expect(data['user']).to eq Api::V1::UserRepresenter.new(registered_user).as_json
      end
    end
  end
end
