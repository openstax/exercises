require 'rails_helper'

module Admin
  describe LicensesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # License. As you add validations to License, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LicensesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all licenses as @licenses" do
        license = License.create! valid_attributes
        get :index, {}, valid_session
        assigns(:licenses).should eq([license])
      end
    end

    describe "GET show" do
      it "assigns the requested license as @license" do
        license = License.create! valid_attributes
        get :show, {:id => license.to_param}, valid_session
        assigns(:license).should eq(license)
      end
    end

    describe "GET new" do
      it "assigns a new license as @license" do
        get :new, {}, valid_session
        assigns(:license).should be_a_new(License)
      end
    end

    describe "GET edit" do
      it "assigns the requested license as @license" do
        license = License.create! valid_attributes
        get :edit, {:id => license.to_param}, valid_session
        assigns(:license).should eq(license)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new License" do
          expect {
            post :create, {:license => valid_attributes}, valid_session
          }.to change(License, :count).by(1)
        end

        it "assigns a newly created license as @license" do
          post :create, {:license => valid_attributes}, valid_session
          assigns(:license).should be_a(License)
          assigns(:license).should be_persisted
        end

        it "redirects to the created license" do
          post :create, {:license => valid_attributes}, valid_session
          response.should redirect_to(License.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved license as @license" do
          # Trigger the behavior that occurs when invalid params are submitted
          License.any_instance.stub(:save).and_return(false)
          post :create, {:license => { "number" => "invalid value" }}, valid_session
          assigns(:license).should be_a_new(License)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          License.any_instance.stub(:save).and_return(false)
          post :create, {:license => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested license" do
          license = License.create! valid_attributes
          # Assuming there are no other licenses in the database, this
          # specifies that the License created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          License.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => license.to_param, :license => { "number" => "1" }}, valid_session
        end

        it "assigns the requested license as @license" do
          license = License.create! valid_attributes
          put :update, {:id => license.to_param, :license => valid_attributes}, valid_session
          assigns(:license).should eq(license)
        end

        it "redirects to the license" do
          license = License.create! valid_attributes
          put :update, {:id => license.to_param, :license => valid_attributes}, valid_session
          response.should redirect_to(license)
        end
      end

      describe "with invalid params" do
        it "assigns the license as @license" do
          license = License.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          License.any_instance.stub(:save).and_return(false)
          put :update, {:id => license.to_param, :license => { "number" => "invalid value" }}, valid_session
          assigns(:license).should eq(license)
        end

        it "re-renders the 'edit' template" do
          license = License.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          License.any_instance.stub(:save).and_return(false)
          put :update, {:id => license.to_param, :license => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested license" do
        license = License.create! valid_attributes
        expect {
          delete :destroy, {:id => license.to_param}, valid_session
        }.to change(License, :count).by(-1)
      end

      it "redirects to the licenses list" do
        license = License.create! valid_attributes
        delete :destroy, {:id => license.to_param}, valid_session
        response.should redirect_to(licenses_url)
      end
    end

  end
end
