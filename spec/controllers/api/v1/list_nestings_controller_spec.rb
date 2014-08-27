require 'rails_helper'

module Api::V1
  RSpec.describe ListNestingsController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # ListNesting. As you add validations to ListNesting, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ListNestingsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all list_nestings as @list_nestings" do
        list_nesting = ListNesting.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:list_nestings)).to eq([list_nesting])
      end
    end

    describe "GET show" do
      it "assigns the requested list_nesting as @list_nesting" do
        list_nesting = ListNesting.create! valid_attributes
        get :show, {:id => list_nesting.to_param}, valid_session
        expect(assigns(:list_nesting)).to eq(list_nesting)
      end
    end

    describe "GET new" do
      it "assigns a new list_nesting as @list_nesting" do
        get :new, {}, valid_session
        expect(assigns(:list_nesting)).to be_a_new(ListNesting)
      end
    end

    describe "GET edit" do
      it "assigns the requested list_nesting as @list_nesting" do
        list_nesting = ListNesting.create! valid_attributes
        get :edit, {:id => list_nesting.to_param}, valid_session
        expect(assigns(:list_nesting)).to eq(list_nesting)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ListNesting" do
          expect {
            post :create, {:list_nesting => valid_attributes}, valid_session
          }.to change(ListNesting, :count).by(1)
        end

        it "assigns a newly created list_nesting as @list_nesting" do
          post :create, {:list_nesting => valid_attributes}, valid_session
          expect(assigns(:list_nesting)).to be_a(ListNesting)
          expect(assigns(:list_nesting)).to be_persisted
        end

        it "redirects to the created list_nesting" do
          post :create, {:list_nesting => valid_attributes}, valid_session
          expect(response).to redirect_to(ListNesting.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved list_nesting as @list_nesting" do
          post :create, {:list_nesting => invalid_attributes}, valid_session
          expect(assigns(:list_nesting)).to be_a_new(ListNesting)
        end

        it "re-renders the 'new' template" do
          post :create, {:list_nesting => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested list_nesting" do
          list_nesting = ListNesting.create! valid_attributes
          put :update, {:id => list_nesting.to_param, :list_nesting => new_attributes}, valid_session
          list_nesting.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested list_nesting as @list_nesting" do
          list_nesting = ListNesting.create! valid_attributes
          put :update, {:id => list_nesting.to_param, :list_nesting => valid_attributes}, valid_session
          expect(assigns(:list_nesting)).to eq(list_nesting)
        end

        it "redirects to the list_nesting" do
          list_nesting = ListNesting.create! valid_attributes
          put :update, {:id => list_nesting.to_param, :list_nesting => valid_attributes}, valid_session
          expect(response).to redirect_to(list_nesting)
        end
      end

      describe "with invalid params" do
        it "assigns the list_nesting as @list_nesting" do
          list_nesting = ListNesting.create! valid_attributes
          put :update, {:id => list_nesting.to_param, :list_nesting => invalid_attributes}, valid_session
          expect(assigns(:list_nesting)).to eq(list_nesting)
        end

        it "re-renders the 'edit' template" do
          list_nesting = ListNesting.create! valid_attributes
          put :update, {:id => list_nesting.to_param, :list_nesting => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested list_nesting" do
        list_nesting = ListNesting.create! valid_attributes
        expect {
          delete :destroy, {:id => list_nesting.to_param}, valid_session
        }.to change(ListNesting, :count).by(-1)
      end

      it "redirects to the list_nestings list" do
        list_nesting = ListNesting.create! valid_attributes
        delete :destroy, {:id => list_nesting.to_param}, valid_session
        expect(response).to redirect_to(list_nestings_url)
      end
    end

  end
end
