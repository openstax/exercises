require "rails_helper"

module Api::V1
  RSpec.describe LogicLibrariesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LogicLibrary. As you add validations to LogicLibrary, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicLibrariesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logic_libraries as @logic_libraries" do
        logic_library = LogicLibrary.create! valid_attributes
        get :index, {}, valid_session
        assigns(:logic_libraries).should eq([logic_library])
      end
    end

    describe "GET show" do
      it "assigns the requested logic_library as @logic_library" do
        logic_library = LogicLibrary.create! valid_attributes
        get :show, {:id => logic_library.to_param}, valid_session
        assigns(:logic_library).should eq(logic_library)
      end
    end

    describe "GET new" do
      it "assigns a new logic_library as @logic_library" do
        get :new, {}, valid_session
        assigns(:logic_library).should be_a_new(LogicLibrary)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic_library as @logic_library" do
        logic_library = LogicLibrary.create! valid_attributes
        get :edit, {:id => logic_library.to_param}, valid_session
        assigns(:logic_library).should eq(logic_library)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LogicLibrary" do
          expect {
            post :create, {:logic_library => valid_attributes}, valid_session
          }.to change(LogicLibrary, :count).by(1)
        end

        it "assigns a newly created logic_library as @logic_library" do
          post :create, {:logic_library => valid_attributes}, valid_session
          assigns(:logic_library).should be_a(LogicLibrary)
          assigns(:logic_library).should be_persisted
        end

        it "redirects to the created logic_library" do
          post :create, {:logic_library => valid_attributes}, valid_session
          response.should redirect_to(LogicLibrary.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic_library as @logic_library" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibrary.any_instance.stub(:save).and_return(false)
          post :create, {:logic_library => { "number" => "invalid value" }}, valid_session
          assigns(:logic_library).should be_a_new(LogicLibrary)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibrary.any_instance.stub(:save).and_return(false)
          post :create, {:logic_library => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested logic_library" do
          logic_library = LogicLibrary.create! valid_attributes
          # Assuming there are no other logic_libraries in the database, this
          # specifies that the LogicLibrary created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LogicLibrary.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => logic_library.to_param, :logic_library => { "number" => "1" }}, valid_session
        end

        it "assigns the requested logic_library as @logic_library" do
          logic_library = LogicLibrary.create! valid_attributes
          put :update, {:id => logic_library.to_param, :logic_library => valid_attributes}, valid_session
          assigns(:logic_library).should eq(logic_library)
        end

        it "redirects to the logic_library" do
          logic_library = LogicLibrary.create! valid_attributes
          put :update, {:id => logic_library.to_param, :logic_library => valid_attributes}, valid_session
          response.should redirect_to(logic_library)
        end
      end

      describe "with invalid params" do
        it "assigns the logic_library as @logic_library" do
          logic_library = LogicLibrary.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibrary.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_library.to_param, :logic_library => { "number" => "invalid value" }}, valid_session
          assigns(:logic_library).should eq(logic_library)
        end

        it "re-renders the 'edit' template" do
          logic_library = LogicLibrary.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicLibrary.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_library.to_param, :logic_library => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic_library" do
        logic_library = LogicLibrary.create! valid_attributes
        expect {
          delete :destroy, {:id => logic_library.to_param}, valid_session
        }.to change(LogicLibrary, :count).by(-1)
      end

      it "redirects to the logic_libraries list" do
        logic_library = LogicLibrary.create! valid_attributes
        delete :destroy, {:id => logic_library.to_param}, valid_session
        response.should redirect_to(logic_libraries_url)
      end
    end

  end
end
