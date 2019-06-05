require "rails_helper"

module Oauth
  RSpec.describe ApplicationsController, type: :controller do

    let(:user_1) { FactoryBot.create :user }
    let(:user_2) { FactoryBot.create :user }
    let(:admin)  { FactoryBot.create(:administrator).user }

    let(:user_group_1) {
      ug = FactoryBot.create :openstax_accounts_group
      ug.add_member(user_1.account)
      ug.add_member(user_2.account)
      ug
    }

    let(:user_group_2) {
      ug = FactoryBot.create :openstax_accounts_group
      ug.add_member(user_2.account)
      ug
    }

    let!(:group_1_application_1) { FactoryBot.create :doorkeeper_application,
                                                      owner: user_group_1 }
    let!(:group_1_application_2) { FactoryBot.create :doorkeeper_application,
                                                      owner: user_group_1 }
    let!(:group_2_application_1) { FactoryBot.create :doorkeeper_application,
                                                      owner: user_group_2 }
    let!(:group_2_application_2) { FactoryBot.create :doorkeeper_application,
                                                      owner: user_group_2 }

    let(:valid_session) { { "account_id" => user_1.account_id } }
    let(:admin_session) { { "account_id" => admin.account_id } }

    context "GET index" do
      it "assigns the user's applications as @applications" do
        get :index, session: valid_session
        expect(response.code).to eq('200')
        expect(assigns :applications).to include(group_1_application_1)
        expect(assigns :applications).to include(group_1_application_2)
        expect(assigns :applications).not_to include(group_2_application_1)
        expect(assigns :applications).not_to include(group_2_application_2)
      end

      it "assigns all applications as @applications for admins" do
        get :index, session: admin_session
        expect(response.code).to eq('200')
        expect(assigns :applications).to include(group_1_application_1)
        expect(assigns :applications).to include(group_1_application_2)
        expect(assigns :applications).to include(group_2_application_1)
        expect(assigns :applications).to include(group_2_application_2)
      end
    end

    context "GET show" do
      it "assigns the requested application as @application" do
        get :show, params: {id: group_1_application_1.to_param}, session: valid_session
        expect(assigns(:application)).to eq(group_1_application_1)
      end
    end

    context "GET new" do
      it "assigns a new application as @application" do
        get :new, session: admin_session
        expect(assigns(:application)).to be_a_new(Doorkeeper::Application)
      end
    end

    context "GET edit" do
      it "assigns the requested application as @application" do
        get :edit, params: {id: group_1_application_1.to_param}, session: valid_session
        expect(assigns(:application)).to eq(group_1_application_1)
      end
    end

    context "POST create" do
      context "with valid params" do
        let(:valid_attributes) { FactoryBot.build(:doorkeeper_application).attributes }

        it "creates a new Application" do
          expect {
            post :create, params: {doorkeeper_application: valid_attributes}, session: admin_session
          }.to change(Doorkeeper::Application, :count).by(1)
        end

        it "assigns a newly created application as @application" do
          post :create, params: {doorkeeper_application: valid_attributes}, session: admin_session
          expect(assigns(:application)).to be_a(Doorkeeper::Application)
          expect(assigns(:application)).to be_persisted
        end

        it "redirects to the created application" do
          post :create, params: {doorkeeper_application: valid_attributes}, session: admin_session
          expect(response).to redirect_to(
            oauth_application_url(Doorkeeper::Application.last)
          )
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved application as @application" do
          # Trigger the behavior that occurs when invalid params are submitted
          post :create, params: {doorkeeper_application: { "redirect_uri" => "invalid" }}, session: admin_session
          expect(assigns(:application)).to be_a_new(Doorkeeper::Application)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          post :create, params: {doorkeeper_application: { "redirect_uri" => "invalid" }}, session: admin_session
          expect(response).to render_template("new")
        end
      end
    end

    context "PATCH update" do
      context "with valid params" do
        dummy_params = ActionController::Parameters.new({ "name" => "Dummy" }).permit!
        it "updates the requested application" do
          expect_any_instance_of(Doorkeeper::Application)
            .to receive(:update_attributes).with(dummy_params)
          patch :update, params: {id: group_1_application_1.to_param,
                          doorkeeper_application: dummy_params}, session: valid_session
        end

        it "assigns the requested application as @application" do
          patch :update, params: {id: group_1_application_1.to_param,
                          doorkeeper_application: dummy_params}, session: valid_session
          expect(assigns(:application)).to eq(group_1_application_1)
        end

        it "redirects to the application" do
          patch :update, params: {id: group_1_application_1.to_param,
                          doorkeeper_application: dummy_params}, session: valid_session
          expect(response).to redirect_to(
            oauth_application_url(group_1_application_1)
          )
        end
      end

      context "with invalid params" do
        it "assigns the application as @application" do
          # Trigger the behavior that occurs when invalid params are submitted
          patch :update, params: {id: group_1_application_1.to_param,
                          doorkeeper_application: { "redirect_uri" => "invalid" }}, session: valid_session
          expect(assigns(:application)).to eq(group_1_application_1)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          patch :update, params: {id: group_1_application_1.to_param,
                          doorkeeper_application: { "redirect_uri" => "invalid" }}, session: valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    context "DELETE destroy" do
      it "destroys the requested application" do
        expect {
          delete :destroy, params: {id: group_1_application_1.to_param}, session: admin_session
        }.to change(Doorkeeper::Application, :count).by(-1)
      end

      it "redirects to the applications list" do
        delete :destroy, params: {id: group_1_application_1.to_param}, session: admin_session
        expect(response).to redirect_to(oauth_applications_url)
      end
    end

  end
end
