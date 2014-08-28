require "rails_helper"

module Api::V1
  RSpec.describe LibraryVersionsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LibraryVersion. As you add validations to LibraryVersion, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LibraryVersionsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all library_versions as @library_versions" do
        library_version = LibraryVersion.create! valid_attributes
        get :index, {}, valid_session
        assigns(:library_versions).should eq([library_version])
      end
    end

    describe "GET show" do
      it "assigns the requested library_version as @library_version" do
        library_version = LibraryVersion.create! valid_attributes
        get :show, {:id => library_version.to_param}, valid_session
        assigns(:library_version).should eq(library_version)
      end
    end

    describe "GET new" do
      it "assigns a new library_version as @library_version" do
        get :new, {}, valid_session
        assigns(:library_version).should be_a_new(LibraryVersion)
      end
    end

    describe "GET edit" do
      it "assigns the requested library_version as @library_version" do
        library_version = LibraryVersion.create! valid_attributes
        get :edit, {:id => library_version.to_param}, valid_session
        assigns(:library_version).should eq(library_version)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LibraryVersion" do
          expect {
            post :create, {:library_version => valid_attributes}, valid_session
          }.to change(LibraryVersion, :count).by(1)
        end

        it "assigns a newly created library_version as @library_version" do
          post :create, {:library_version => valid_attributes}, valid_session
          assigns(:library_version).should be_a(LibraryVersion)
          assigns(:library_version).should be_persisted
        end

        it "redirects to the created library_version" do
          post :create, {:library_version => valid_attributes}, valid_session
          response.should redirect_to(LibraryVersion.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved library_version as @library_version" do
          # Trigger the behavior that occurs when invalid params are submitted
          LibraryVersion.any_instance.stub(:save).and_return(false)
          post :create, {:library_version => { "number" => "invalid value" }}, valid_session
          assigns(:library_version).should be_a_new(LibraryVersion)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LibraryVersion.any_instance.stub(:save).and_return(false)
          post :create, {:library_version => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested library_version" do
          library_version = LibraryVersion.create! valid_attributes
          # Assuming there are no other library_versions in the database, this
          # specifies that the LibraryVersion created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LibraryVersion.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => library_version.to_param, :library_version => { "number" => "1" }}, valid_session
        end

        it "assigns the requested library_version as @library_version" do
          library_version = LibraryVersion.create! valid_attributes
          put :update, {:id => library_version.to_param, :library_version => valid_attributes}, valid_session
          assigns(:library_version).should eq(library_version)
        end

        it "redirects to the library_version" do
          library_version = LibraryVersion.create! valid_attributes
          put :update, {:id => library_version.to_param, :library_version => valid_attributes}, valid_session
          response.should redirect_to(library_version)
        end
      end

      describe "with invalid params" do
        it "assigns the library_version as @library_version" do
          library_version = LibraryVersion.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LibraryVersion.any_instance.stub(:save).and_return(false)
          put :update, {:id => library_version.to_param, :library_version => { "number" => "invalid value" }}, valid_session
          assigns(:library_version).should eq(library_version)
        end

        it "re-renders the 'edit' template" do
          library_version = LibraryVersion.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LibraryVersion.any_instance.stub(:save).and_return(false)
          put :update, {:id => library_version.to_param, :library_version => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested library_version" do
        library_version = LibraryVersion.create! valid_attributes
        expect {
          delete :destroy, {:id => library_version.to_param}, valid_session
        }.to change(LibraryVersion, :count).by(-1)
      end

      it "redirects to the library_versions list" do
        library_version = LibraryVersion.create! valid_attributes
        delete :destroy, {:id => library_version.to_param}, valid_session
        response.should redirect_to(library_versions_url)
      end
    end

  end
end
