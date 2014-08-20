require 'spec_helper'

module Api::V1
  describe DerivationsController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # Derivation. As you add validations to Derivation, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "publishable_type" => "MyString" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # DerivationsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all derivations as @derivations" do
        derivation = Derivation.create! valid_attributes
        get :index, {}, valid_session
        assigns(:derivations).should eq([derivation])
      end
    end

    describe "GET show" do
      it "assigns the requested derivation as @derivation" do
        derivation = Derivation.create! valid_attributes
        get :show, {:id => derivation.to_param}, valid_session
        assigns(:derivation).should eq(derivation)
      end
    end

    describe "GET new" do
      it "assigns a new derivation as @derivation" do
        get :new, {}, valid_session
        assigns(:derivation).should be_a_new(Derivation)
      end
    end

    describe "GET edit" do
      it "assigns the requested derivation as @derivation" do
        derivation = Derivation.create! valid_attributes
        get :edit, {:id => derivation.to_param}, valid_session
        assigns(:derivation).should eq(derivation)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Derivation" do
          expect {
            post :create, {:derivation => valid_attributes}, valid_session
          }.to change(Derivation, :count).by(1)
        end

        it "assigns a newly created derivation as @derivation" do
          post :create, {:derivation => valid_attributes}, valid_session
          assigns(:derivation).should be_a(Derivation)
          assigns(:derivation).should be_persisted
        end

        it "redirects to the created derivation" do
          post :create, {:derivation => valid_attributes}, valid_session
          response.should redirect_to(Derivation.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved derivation as @derivation" do
          # Trigger the behavior that occurs when invalid params are submitted
          Derivation.any_instance.stub(:save).and_return(false)
          post :create, {:derivation => { "publishable_type" => "invalid value" }}, valid_session
          assigns(:derivation).should be_a_new(Derivation)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Derivation.any_instance.stub(:save).and_return(false)
          post :create, {:derivation => { "publishable_type" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested derivation" do
          derivation = Derivation.create! valid_attributes
          # Assuming there are no other derivations in the database, this
          # specifies that the Derivation created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Derivation.any_instance.should_receive(:update_attributes).with({ "publishable_type" => "MyString" })
          put :update, {:id => derivation.to_param, :derivation => { "publishable_type" => "MyString" }}, valid_session
        end

        it "assigns the requested derivation as @derivation" do
          derivation = Derivation.create! valid_attributes
          put :update, {:id => derivation.to_param, :derivation => valid_attributes}, valid_session
          assigns(:derivation).should eq(derivation)
        end

        it "redirects to the derivation" do
          derivation = Derivation.create! valid_attributes
          put :update, {:id => derivation.to_param, :derivation => valid_attributes}, valid_session
          response.should redirect_to(derivation)
        end
      end

      describe "with invalid params" do
        it "assigns the derivation as @derivation" do
          derivation = Derivation.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Derivation.any_instance.stub(:save).and_return(false)
          put :update, {:id => derivation.to_param, :derivation => { "publishable_type" => "invalid value" }}, valid_session
          assigns(:derivation).should eq(derivation)
        end

        it "re-renders the 'edit' template" do
          derivation = Derivation.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Derivation.any_instance.stub(:save).and_return(false)
          put :update, {:id => derivation.to_param, :derivation => { "publishable_type" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested derivation" do
        derivation = Derivation.create! valid_attributes
        expect {
          delete :destroy, {:id => derivation.to_param}, valid_session
        }.to change(Derivation, :count).by(-1)
      end

      it "redirects to the derivations list" do
        derivation = Derivation.create! valid_attributes
        delete :destroy, {:id => derivation.to_param}, valid_session
        response.should redirect_to(derivations_url)
      end
    end

  end
end