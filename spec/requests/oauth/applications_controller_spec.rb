require 'rails_helper'

RSpec.describe Oauth::ApplicationsController, type: :request do
  let(:user_1) { FactoryBot.create :user }
  let(:user_2) { FactoryBot.create :user }
  let(:admin)  { FactoryBot.create(:administrator).user }

  let!(:user_1_application_1) { FactoryBot.create :doorkeeper_application, owner: user_1 }
  let!(:user_1_application_2) { FactoryBot.create :doorkeeper_application, owner: user_1 }
  let!(:user_2_application_1) { FactoryBot.create :doorkeeper_application, owner: user_2 }
  let!(:user_2_application_2) { FactoryBot.create :doorkeeper_application, owner: user_2 }

  context "GET /oauth/applications" do
    it "renders a list of the user's applications" do
      sign_in user_1
      get oauth_applications_url

      expect(response).to have_http_status(:ok)
      expect(css_select("#application_#{user_1_application_1.id}")).not_to be_empty
      expect(css_select("#application_#{user_1_application_2.id}")).not_to be_empty
      expect(css_select("#application_#{user_2_application_1.id}")).to be_empty
      expect(css_select("#application_#{user_2_application_2.id}")).to be_empty
    end

    it "renders a list of all applications for admins" do
      sign_in admin
      get oauth_applications_url

      expect(response).to have_http_status(:ok)
      expect(css_select("#application_#{user_1_application_1.id}")).not_to be_empty
      expect(css_select("#application_#{user_1_application_2.id}")).not_to be_empty
      expect(css_select("#application_#{user_2_application_1.id}")).not_to be_empty
      expect(css_select("#application_#{user_2_application_2.id}")).not_to be_empty
    end
  end

  context "GET /oauth/applications/:id" do
    before { sign_in user_1 }

    it "renders the requested application" do
      get oauth_application_url(user_1_application_1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user_1_application_1.id.to_s)
      expect(response.body).to include(user_1_application_1.name)
      expect(response.body).to include(user_1_application_1.uid)
      expect(response.body).to include(user_1_application_1.secret)
      expect(response.body).to include(user_1_application_1.redirect_uri)
    end
  end

  context "GET /oauth/applications/new" do
    before { sign_in admin }

    it "renders a form for a new application" do
      get new_oauth_application_url

      expect(response).to have_http_status(:ok)
      expect(css_select('form#new_doorkeeper_application')).not_to be_empty
      expect(css_select('input[type=submit]')).not_to be_empty
    end
  end

  context "GET /oauth/applications/:id/edit" do
    before { sign_in user_1 }

    it "renders a form for the requested application" do
      get edit_oauth_application_url(user_1_application_1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user_1_application_1.name)
      expect(response.body).to include(user_1_application_1.redirect_uri)
    end
  end

  context "POST /oauth/applications" do
    before { sign_in admin }

    context "with valid params" do
      let(:valid_attributes) { FactoryBot.build(:doorkeeper_application).attributes }

      it "creates a new application and redirects to it" do
        expect do
          post oauth_applications_url, params: { doorkeeper_application: valid_attributes }
        end.to change(Doorkeeper::Application, :count).by(1)

        new_app = Doorkeeper::Application.order(:created_at).last
        [ :name, :redirect_uri, :confidential ].each do |attribute|
          expect(new_app.send attribute).to eq valid_attributes[attribute.to_s]
        end
        expect(response).to redirect_to oauth_application_url(new_app)
      end
    end

    context "with invalid params" do
      it "displays the error" do
        # Trigger the behavior that occurs when invalid params are submitted
        post oauth_applications_url, params: { doorkeeper_application: { redirect_uri: "invalid" } }

        expect(css_select('#doorkeeper_application_redirect_uri.is-invalid')).not_to be_empty
      end
    end
  end

  context "PATCH /oauth/applications/:id" do
    before { sign_in user_1 }

    context "with valid params" do
      let(:dummy_params) { ActionController::Parameters.new(name: 'Dummy').permit! }

      it "updates the requested application and redirects to it" do
        expect_any_instance_of(Doorkeeper::Application).to(
          receive(:update).with(dummy_params).and_call_original
        )

        patch oauth_application_url(user_1_application_1),
              params: { doorkeeper_application: dummy_params.to_h }

        expect(user_1_application_1.reload.name).to eq 'Dummy'
        expect(response).to redirect_to oauth_application_url(user_1_application_1)
      end
    end

    context "with invalid params" do
      it "displays the error" do
        # Trigger the behavior that occurs when invalid params are submitted
        patch oauth_application_url(user_1_application_1),
              params: { doorkeeper_application: { redirect_uri: "invalid" } }

        expect(css_select('#doorkeeper_application_redirect_uri.is-invalid')).not_to be_empty
      end
    end
  end

  context "DELETE /oauth/applications/:id" do
    before { sign_in admin }

    it "destroys the requested application and redirects to the applications list" do
      expect do
        delete oauth_application_url(user_1_application_1)
      end.to change(Doorkeeper::Application, :count).by(-1)

      expect(response).to redirect_to(oauth_applications_url)
    end
  end
end
