require 'rails_helper'

module Api::V1
  RSpec.describe SortsController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # Sort. As you add validations to Sort, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # SortsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all sorts as @sorts" do
        sort = Sort.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:sorts)).to eq([sort])
      end
    end

    describe "GET show" do
      it "assigns the requested sort as @sort" do
        sort = Sort.create! valid_attributes
        get :show, {:id => sort.to_param}, valid_session
        expect(assigns(:sort)).to eq(sort)
      end
    end

    describe "GET new" do
      it "assigns a new sort as @sort" do
        get :new, {}, valid_session
        expect(assigns(:sort)).to be_a_new(Sort)
      end
    end

    describe "GET edit" do
      it "assigns the requested sort as @sort" do
        sort = Sort.create! valid_attributes
        get :edit, {:id => sort.to_param}, valid_session
        expect(assigns(:sort)).to eq(sort)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Sort" do
          expect {
            post :create, {:sort => valid_attributes}, valid_session
          }.to change(Sort, :count).by(1)
        end

        it "assigns a newly created sort as @sort" do
          post :create, {:sort => valid_attributes}, valid_session
          expect(assigns(:sort)).to be_a(Sort)
          expect(assigns(:sort)).to be_persisted
        end

        it "redirects to the created sort" do
          post :create, {:sort => valid_attributes}, valid_session
          expect(response).to redirect_to(Sort.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved sort as @sort" do
          post :create, {:sort => invalid_attributes}, valid_session
          expect(assigns(:sort)).to be_a_new(Sort)
        end

        it "re-renders the 'new' template" do
          post :create, {:sort => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested sort" do
          sort = Sort.create! valid_attributes
          put :update, {:id => sort.to_param, :sort => new_attributes}, valid_session
          sort.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested sort as @sort" do
          sort = Sort.create! valid_attributes
          put :update, {:id => sort.to_param, :sort => valid_attributes}, valid_session
          expect(assigns(:sort)).to eq(sort)
        end

        it "redirects to the sort" do
          sort = Sort.create! valid_attributes
          put :update, {:id => sort.to_param, :sort => valid_attributes}, valid_session
          expect(response).to redirect_to(sort)
        end
      end

      describe "with invalid params" do
        it "assigns the sort as @sort" do
          sort = Sort.create! valid_attributes
          put :update, {:id => sort.to_param, :sort => invalid_attributes}, valid_session
          expect(assigns(:sort)).to eq(sort)
        end

        it "re-renders the 'edit' template" do
          sort = Sort.create! valid_attributes
          put :update, {:id => sort.to_param, :sort => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested sort" do
        sort = Sort.create! valid_attributes
        expect {
          delete :destroy, {:id => sort.to_param}, valid_session
        }.to change(Sort, :count).by(-1)
      end

      it "redirects to the sorts list" do
        sort = Sort.create! valid_attributes
        delete :destroy, {:id => sort.to_param}, valid_session
        expect(response).to redirect_to(sorts_url)
      end
    end

  end
end
