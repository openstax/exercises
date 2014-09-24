require "rails_helper"

module Api::V1
  RSpec.describe LibrariesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Library. As you add validations to Library, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LibrariesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all libraries as @libraries" do
        library = Library.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:libraries)).to eq([library])
      end
    end

    describe "GET show" do
      it "assigns the requested library as @library" do
        library = Library.create! valid_attributes
        get :show, {:id => library.to_param}, valid_session
        expect(assigns(:library)).to eq(library)
      end
    end

    describe "GET new" do
      it "assigns a new library as @library" do
        get :new, {}, valid_session
        expect(assigns(:library)).to be_a_new(Library)
      end
    end

    describe "GET edit" do
      it "assigns the requested library as @library" do
        library = Library.create! valid_attributes
        get :edit, {:id => library.to_param}, valid_session
        expect(assigns(:library)).to eq(library)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Library" do
          expect {
            post :create, {:library => valid_attributes}, valid_session
          }.to change(Library, :count).by(1)
        end

        it "assigns a newly created library as @library" do
          post :create, {:library => valid_attributes}, valid_session
          expect(assigns(:library)).to be_a(Library)
          expect(assigns(:library)).to be_persisted
        end

        it "redirects to the created library" do
          post :create, {:library => valid_attributes}, valid_session
          expect(response).to redirect_to(Library.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved library as @library" do
          # Trigger the behavior that occurs when invalid params are submitted
          Library.any_instance.stub(:save).and_return(false)
          post :create, {:library => { "number" => "invalid value" }}, valid_session
          expect(assigns(:library)).to be_a_new(Library)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Library.any_instance.stub(:save).and_return(false)
          post :create, {:library => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested library" do
          library = Library.create! valid_attributes
          # Assuming there are no other libraries in the database, this
          # specifies that the Library created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect(Library.any_instance).to_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => library.to_param, :library => { "number" => "1" }}, valid_session
        end

        it "assigns the requested library as @library" do
          library = Library.create! valid_attributes
          put :update, {:id => library.to_param, :library => valid_attributes}, valid_session
          expect(assigns(:library)).to eq(library)
        end

        it "redirects to the library" do
          library = Library.create! valid_attributes
          put :update, {:id => library.to_param, :library => valid_attributes}, valid_session
          expect(response).to redirect_to(library)
        end
      end

      describe "with invalid params" do
        it "assigns the library as @library" do
          library = Library.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Library.any_instance.stub(:save).and_return(false)
          put :update, {:id => library.to_param, :library => { "number" => "invalid value" }}, valid_session
          expect(assigns(:library)).to eq(library)
        end

        it "re-renders the 'edit' template" do
          library = Library.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Library.any_instance.stub(:save).and_return(false)
          put :update, {:id => library.to_param, :library => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested library" do
        library = Library.create! valid_attributes
        expect {
          delete :destroy, {:id => library.to_param}, valid_session
        }.to change(Library, :count).by(-1)
      end

      it "redirects to the libraries list" do
        library = Library.create! valid_attributes
        delete :destroy, {:id => library.to_param}, valid_session
        expect(response).to redirect_to(libraries_url)
      end
    end

  end
end
