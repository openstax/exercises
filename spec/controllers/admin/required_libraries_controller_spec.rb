require 'rails_helper'

module Admin
  RSpec.describe RequiredLibrariesController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # RequiredLibrary. As you add validations to RequiredLibrary, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # RequiredLibrariesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all required_libraries as @required_libraries" do
        required_library = RequiredLibrary.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:required_libraries)).to eq([required_library])
      end
    end

    describe "GET show" do
      it "assigns the requested required_library as @required_library" do
        required_library = RequiredLibrary.create! valid_attributes
        get :show, {:id => required_library.to_param}, valid_session
        expect(assigns(:required_library)).to eq(required_library)
      end
    end

    describe "GET new" do
      it "assigns a new required_library as @required_library" do
        get :new, {}, valid_session
        expect(assigns(:required_library)).to be_a_new(RequiredLibrary)
      end
    end

    describe "GET edit" do
      it "assigns the requested required_library as @required_library" do
        required_library = RequiredLibrary.create! valid_attributes
        get :edit, {:id => required_library.to_param}, valid_session
        expect(assigns(:required_library)).to eq(required_library)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new RequiredLibrary" do
          expect {
            post :create, {:required_library => valid_attributes}, valid_session
          }.to change(RequiredLibrary, :count).by(1)
        end

        it "assigns a newly created required_library as @required_library" do
          post :create, {:required_library => valid_attributes}, valid_session
          expect(assigns(:required_library)).to be_a(RequiredLibrary)
          expect(assigns(:required_library)).to be_persisted
        end

        it "redirects to the created required_library" do
          post :create, {:required_library => valid_attributes}, valid_session
          expect(response).to redirect_to(RequiredLibrary.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved required_library as @required_library" do
          post :create, {:required_library => invalid_attributes}, valid_session
          expect(assigns(:required_library)).to be_a_new(RequiredLibrary)
        end

        it "re-renders the 'new' template" do
          post :create, {:required_library => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested required_library" do
          required_library = RequiredLibrary.create! valid_attributes
          put :update, {:id => required_library.to_param, :required_library => new_attributes}, valid_session
          required_library.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested required_library as @required_library" do
          required_library = RequiredLibrary.create! valid_attributes
          put :update, {:id => required_library.to_param, :required_library => valid_attributes}, valid_session
          expect(assigns(:required_library)).to eq(required_library)
        end

        it "redirects to the required_library" do
          required_library = RequiredLibrary.create! valid_attributes
          put :update, {:id => required_library.to_param, :required_library => valid_attributes}, valid_session
          expect(response).to redirect_to(required_library)
        end
      end

      describe "with invalid params" do
        it "assigns the required_library as @required_library" do
          required_library = RequiredLibrary.create! valid_attributes
          put :update, {:id => required_library.to_param, :required_library => invalid_attributes}, valid_session
          expect(assigns(:required_library)).to eq(required_library)
        end

        it "re-renders the 'edit' template" do
          required_library = RequiredLibrary.create! valid_attributes
          put :update, {:id => required_library.to_param, :required_library => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested required_library" do
        required_library = RequiredLibrary.create! valid_attributes
        expect {
          delete :destroy, {:id => required_library.to_param}, valid_session
        }.to change(RequiredLibrary, :count).by(-1)
      end

      it "redirects to the required_libraries list" do
        required_library = RequiredLibrary.create! valid_attributes
        delete :destroy, {:id => required_library.to_param}, valid_session
        expect(response).to redirect_to(required_libraries_url)
      end
    end

  end
end
