require 'rails_helper'

RSpec.describe WebviewController, type: :controller do

  let!(:contract)        { FinePrint::Contract.create!(name: 'general_terms_of_use', title: 'General Terms of Use',
                           content: Faker::Lorem.paragraphs, version: 10) }
  let!(:new_user)        { FactoryGirl.create(:user) }
  let!(:registered_user) { FactoryGirl.create(:user, :agreed_to_terms) }

  describe 'GET home' do
    it 'renders a static page for anonymous' do
      get :home
      expect(response).to have_http_status(:success)
    end

    xit 'redirects logged in users to the dashboard' do
      controller.sign_in new_user
      get :home
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe 'GET index' do
    it 'requires a user' do
      get :index
      expect(response).to redirect_to(controller.openstax_accounts.login_path)
    end

    it 'requires agreement to contracts' do
      controller.sign_in new_user
      get :index
      expect(response).to have_http_status(:found)
    end

    it 'returns http success' do
      controller.sign_in registered_user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  context "as a signed in user" do
    render_views

    it 'sets boostrap data in script tag' do
      controller.sign_in registered_user
      get :index
      expect(response).to have_http_status(:success)
      doc = Nokogiri::HTML(response.body)
      data = ::JSON.parse(doc.css('script#exercises-boostrap-data').inner_text)
      expect(data).to include({
        'user' => Api::V1::UserRepresenter.new(registered_user).as_json
      })
    end
  end

end
