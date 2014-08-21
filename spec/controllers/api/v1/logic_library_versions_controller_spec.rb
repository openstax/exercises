require 'rails_helper'

module Api::V1
  describe LogicLibraryVersionsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LogicLibraryVersion. As you add validations to LogicLibraryVersion, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicLibraryVersionsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logic_library_versions as @logic_library_versions" do
        logic_library_version = LogicLibraryVersion.create! valid_attributes
        get :index, {}, valid_session
        assigns(:logic_library_versions).should eq([logic_library_version])
      end
    end

    describe "GET show" do
      it "assigns the requested logic_library_version as @logic_library_version" do
        logic_library_version = LogicLibraryVersion.create! valid_attributes
        get :show, {:id => logic_library_version.to_param}, valid_session
        assigns(:logic_library_version).should eq(logic_library_version)
      end
    end

    describe "GET new" do
      it "assigns a new logic_library_version as @logic_library_version" do
        get :new, {}, valid_session
        assigns(:logic_library_version).should be_a_new(LogicLibraryVersion)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic_library_version as @logic_library_version" do
        logic_library_version = LogicLibraryVersion.create! valid_attributes
        get :edit, {:id => logic_library_version.to_param}, valid_session
        assigns(:logic_library_version).should eq(logic_library_version)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LogicLibraryVersion" do
          expect {
            post :create, {:logic_library_version => valid_attributes}, valid_session
          }.to change(LogicLibraryVersion, :count).by(1)
        end

        it "assigns a newly created logic_library_version as @logic_library_version" do
          post :create, {:logic_library_version => valid_attributes}, valid_session
          assigns(:logic_library_version).should be_a(LogicLibraryVersion)
          assigns(:logic_library_version).should be_persisted
        end

        it "redirects to the created logic_library_version" do
          post :create, {:logic_library_version => valid_attributes}, valid_session
          response.should redirect_to(LogicLibraryVersion.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic_library_version as @logic_library_version" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibraryVersion.any_instance.stub(:save).and_return(false)
          post :create, {:logic_library_version => { "number" => "invalid value" }}, valid_session
          assigns(:logic_library_version).should be_a_new(LogicLibraryVersion)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibraryVersion.any_instance.stub(:save).and_return(false)
          post :create, {:logic_library_version => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested logic_library_version" do
          logic_library_version = LogicLibraryVersion.create! valid_attributes
          # Assuming there are no other logic_library_versions in the database, this
          # specifies that the LogicLibraryVersion created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LogicLibraryVersion.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => logic_library_version.to_param, :logic_library_version => { "number" => "1" }}, valid_session
        end

        it "assigns the requested logic_library_version as @logic_library_version" do
          logic_library_version = LogicLibraryVersion.create! valid_attributes
          put :update, {:id => logic_library_version.to_param, :logic_library_version => valid_attributes}, valid_session
          assigns(:logic_library_version).should eq(logic_library_version)
        end

        it "redirects to the logic_library_version" do
          logic_library_version = LogicLibraryVersion.create! valid_attributes
          put :update, {:id => logic_library_version.to_param, :logic_library_version => valid_attributes}, valid_session
          response.should redirect_to(logic_library_version)
        end
      end

      describe "with invalid params" do
        it "assigns the logic_library_version as @logic_library_version" do
          logic_library_version = LogicLibraryVersion.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibraryVersion.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_library_version.to_param, :logic_library_version => { "number" => "invalid value" }}, valid_session
          assigns(:logic_library_version).should eq(logic_library_version)
        end

        it "re-renders the 'edit' template" do
          logic_library_version = LogicLibraryVersion.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibraryVersion.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_library_version.to_param, :logic_library_version => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic_library_version" do
        logic_library_version = LogicLibraryVersion.create! valid_attributes
        expect {
          delete :destroy, {:id => logic_library_version.to_param}, valid_session
        }.to change(LogicLibraryVersion, :count).by(-1)
      end

      it "redirects to the logic_library_versions list" do
        logic_library_version = LogicLibraryVersion.create! valid_attributes
        delete :destroy, {:id => logic_library_version.to_param}, valid_session
        response.should redirect_to(logic_library_versions_url)
      end
    end

  end
end
