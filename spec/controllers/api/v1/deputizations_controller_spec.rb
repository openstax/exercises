require "rails_helper"

module Api::V1
  RSpec.describe DeputizationsController, type: :controller, api: true, version: :v1 do

    before do
      # To be implemented
      skip
    end

    context "GET index" do
      it "assigns all deputizations as @deputizations" do
        deputization = Deputization.create! valid_attributes
        get :index, session: valid_session
        expect(assigns(:deputizations)).to eq([deputization])
      end
    end

    context "POST create" do
      context "with valid params" do
        it "creates a new Deputization" do
          expect {
            post :create, params: { :deputization => valid_attributes }, session: valid_session
          }.to change(Deputization, :count).by(1)
        end

        it "assigns a newly created deputization as @deputization" do
          post :create, params: { :deputization => valid_attributes }, session: valid_session
          expect(assigns(:deputization)).to be_a(Deputization)
          expect(assigns(:deputization)).to be_persisted
        end

        it "redirects to the created deputization" do
          post :create, params: { :deputization => valid_attributes }, session: valid_session
          expect(response).to redirect_to(Deputization.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved deputization as @deputization" do
          # Trigger the behavior that occurs when invalid params are submitted
          Deputization.any_instance.stub(:save).and_return(false)
          post :create, params: { :deputization => { "number" => "invalid value" } }, session: valid_session
          expect(assigns(:deputization)).to be_a_new(Deputization)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Deputization.any_instance.stub(:save).and_return(false)
          post :create, params: { :deputization => { "number" => "invalid value" } }, session: valid_session
          expect(response).to render_template("new")
        end
      end
    end

    context "DELETE destroy" do
      it "destroys the requested deputization" do
        deputization = Deputization.create! valid_attributes
        expect {
          delete :destroy, params: { id: deputization.to_param }, session: valid_session
        }.to change(Deputization, :count).by(-1)
      end

      it "redirects to the deputizations list" do
        deputization = Deputization.create! valid_attributes
        delete :destroy, params: { id: deputization.to_param }, session: valid_session
        expect(response).to redirect_to(deputizations_url)
      end
    end

  end
end
