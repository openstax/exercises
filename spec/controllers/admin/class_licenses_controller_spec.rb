require "rails_helper"

module Admin
  RSpec.describe ClassLicensesController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # ClassLicense. As you add validations to ClassLicense, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ClassLicensesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all class_licenses as @class_licenses" do
        class_license = ClassLicense.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:class_licenses)).to eq([class_license])
      end
    end

    describe "GET show" do
      it "assigns the requested class_license as @class_license" do
        class_license = ClassLicense.create! valid_attributes
        get :show, {:id => class_license.to_param}, valid_session
        expect(assigns(:class_license)).to eq(class_license)
      end
    end

    describe "GET new" do
      it "assigns a new class_license as @class_license" do
        get :new, {}, valid_session
        expect(assigns(:class_license)).to be_a_new(ClassLicense)
      end
    end

    describe "GET edit" do
      it "assigns the requested class_license as @class_license" do
        class_license = ClassLicense.create! valid_attributes
        get :edit, {:id => class_license.to_param}, valid_session
        expect(assigns(:class_license)).to eq(class_license)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ClassLicense" do
          expect {
            post :create, {:class_license => valid_attributes}, valid_session
          }.to change(ClassLicense, :count).by(1)
        end

        it "assigns a newly created class_license as @class_license" do
          post :create, {:class_license => valid_attributes}, valid_session
          expect(assigns(:class_license)).to be_a(ClassLicense)
          expect(assigns(:class_license)).to be_persisted
        end

        it "redirects to the created class_license" do
          post :create, {:class_license => valid_attributes}, valid_session
          expect(response).to redirect_to(ClassLicense.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved class_license as @class_license" do
          post :create, {:class_license => invalid_attributes}, valid_session
          expect(assigns(:class_license)).to be_a_new(ClassLicense)
        end

        it "re-renders the 'new' template" do
          post :create, {:class_license => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested class_license" do
          class_license = ClassLicense.create! valid_attributes
          put :update, {:id => class_license.to_param, :class_license => new_attributes}, valid_session
          class_license.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested class_license as @class_license" do
          class_license = ClassLicense.create! valid_attributes
          put :update, {:id => class_license.to_param, :class_license => valid_attributes}, valid_session
          expect(assigns(:class_license)).to eq(class_license)
        end

        it "redirects to the class_license" do
          class_license = ClassLicense.create! valid_attributes
          put :update, {:id => class_license.to_param, :class_license => valid_attributes}, valid_session
          expect(response).to redirect_to(class_license)
        end
      end

      describe "with invalid params" do
        it "assigns the class_license as @class_license" do
          class_license = ClassLicense.create! valid_attributes
          put :update, {:id => class_license.to_param, :class_license => invalid_attributes}, valid_session
          expect(assigns(:class_license)).to eq(class_license)
        end

        it "re-renders the 'edit' template" do
          class_license = ClassLicense.create! valid_attributes
          put :update, {:id => class_license.to_param, :class_license => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested class_license" do
        class_license = ClassLicense.create! valid_attributes
        expect {
          delete :destroy, {:id => class_license.to_param}, valid_session
        }.to change(ClassLicense, :count).by(-1)
      end

      it "redirects to the class_licenses list" do
        class_license = ClassLicense.create! valid_attributes
        delete :destroy, {:id => class_license.to_param}, valid_session
        expect(response).to redirect_to(class_licenses_url)
      end
    end

  end
end
