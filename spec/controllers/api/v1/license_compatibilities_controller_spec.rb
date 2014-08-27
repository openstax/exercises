require 'rails_helper'

module Api::V1
  describe LicenseCompatibilitiesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LicenseCompatibility. As you add validations to LicenseCompatibility, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LicenseCompatibilitiesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all license_compatibilities as @license_compatibilities" do
        license_compatibility = LicenseCompatibility.create! valid_attributes
        get :index, {}, valid_session
        assigns(:license_compatibilities).should eq([license_compatibility])
      end
    end

    describe "GET show" do
      it "assigns the requested license_compatibility as @license_compatibility" do
        license_compatibility = LicenseCompatibility.create! valid_attributes
        get :show, {:id => license_compatibility.to_param}, valid_session
        assigns(:license_compatibility).should eq(license_compatibility)
      end
    end

    describe "GET new" do
      it "assigns a new license_compatibility as @license_compatibility" do
        get :new, {}, valid_session
        assigns(:license_compatibility).should be_a_new(LicenseCompatibility)
      end
    end

    describe "GET edit" do
      it "assigns the requested license_compatibility as @license_compatibility" do
        license_compatibility = LicenseCompatibility.create! valid_attributes
        get :edit, {:id => license_compatibility.to_param}, valid_session
        assigns(:license_compatibility).should eq(license_compatibility)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LicenseCompatibility" do
          expect {
            post :create, {:license_compatibility => valid_attributes}, valid_session
          }.to change(LicenseCompatibility, :count).by(1)
        end

        it "assigns a newly created license_compatibility as @license_compatibility" do
          post :create, {:license_compatibility => valid_attributes}, valid_session
          assigns(:license_compatibility).should be_a(LicenseCompatibility)
          assigns(:license_compatibility).should be_persisted
        end

        it "redirects to the created license_compatibility" do
          post :create, {:license_compatibility => valid_attributes}, valid_session
          response.should redirect_to(LicenseCompatibility.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved license_compatibility as @license_compatibility" do
          # Trigger the behavior that occurs when invalid params are submitted
          LicenseCompatibility.any_instance.stub(:save).and_return(false)
          post :create, {:license_compatibility => { "number" => "invalid value" }}, valid_session
          assigns(:license_compatibility).should be_a_new(LicenseCompatibility)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LicenseCompatibility.any_instance.stub(:save).and_return(false)
          post :create, {:license_compatibility => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested license_compatibility" do
          license_compatibility = LicenseCompatibility.create! valid_attributes
          # Assuming there are no other license_compatibilities in the database, this
          # specifies that the LicenseCompatibility created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LicenseCompatibility.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => license_compatibility.to_param, :license_compatibility => { "number" => "1" }}, valid_session
        end

        it "assigns the requested license_compatibility as @license_compatibility" do
          license_compatibility = LicenseCompatibility.create! valid_attributes
          put :update, {:id => license_compatibility.to_param, :license_compatibility => valid_attributes}, valid_session
          assigns(:license_compatibility).should eq(license_compatibility)
        end

        it "redirects to the license_compatibility" do
          license_compatibility = LicenseCompatibility.create! valid_attributes
          put :update, {:id => license_compatibility.to_param, :license_compatibility => valid_attributes}, valid_session
          response.should redirect_to(license_compatibility)
        end
      end

      describe "with invalid params" do
        it "assigns the license_compatibility as @license_compatibility" do
          license_compatibility = LicenseCompatibility.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LicenseCompatibility.any_instance.stub(:save).and_return(false)
          put :update, {:id => license_compatibility.to_param, :license_compatibility => { "number" => "invalid value" }}, valid_session
          assigns(:license_compatibility).should eq(license_compatibility)
        end

        it "re-renders the 'edit' template" do
          license_compatibility = LicenseCompatibility.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LicenseCompatibility.any_instance.stub(:save).and_return(false)
          put :update, {:id => license_compatibility.to_param, :license_compatibility => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested license_compatibility" do
        license_compatibility = LicenseCompatibility.create! valid_attributes
        expect {
          delete :destroy, {:id => license_compatibility.to_param}, valid_session
        }.to change(LicenseCompatibility, :count).by(-1)
      end

      it "redirects to the license_compatibilities list" do
        license_compatibility = LicenseCompatibility.create! valid_attributes
        delete :destroy, {:id => license_compatibility.to_param}, valid_session
        response.should redirect_to(license_compatibilities_url)
      end
    end

  end
end
