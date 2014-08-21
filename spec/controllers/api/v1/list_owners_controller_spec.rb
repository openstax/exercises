require 'rails_helper'

module Api::V1
  describe ListOwnersController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # ListOwner. As you add validations to ListOwner, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "list_id" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ListOwnersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all list_owners as @list_owners" do
        list_owner = ListOwner.create! valid_attributes
        get :index, {}, valid_session
        assigns(:list_owners).should eq([list_owner])
      end
    end

    describe "GET show" do
      it "assigns the requested list_owner as @list_owner" do
        list_owner = ListOwner.create! valid_attributes
        get :show, {:id => list_owner.to_param}, valid_session
        assigns(:list_owner).should eq(list_owner)
      end
    end

    describe "GET new" do
      it "assigns a new list_owner as @list_owner" do
        get :new, {}, valid_session
        assigns(:list_owner).should be_a_new(ListOwner)
      end
    end

    describe "GET edit" do
      it "assigns the requested list_owner as @list_owner" do
        list_owner = ListOwner.create! valid_attributes
        get :edit, {:id => list_owner.to_param}, valid_session
        assigns(:list_owner).should eq(list_owner)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ListOwner" do
          expect {
            post :create, {:list_owner => valid_attributes}, valid_session
          }.to change(ListOwner, :count).by(1)
        end

        it "assigns a newly created list_owner as @list_owner" do
          post :create, {:list_owner => valid_attributes}, valid_session
          assigns(:list_owner).should be_a(ListOwner)
          assigns(:list_owner).should be_persisted
        end

        it "redirects to the created list_owner" do
          post :create, {:list_owner => valid_attributes}, valid_session
          response.should redirect_to(ListOwner.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved list_owner as @list_owner" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListOwner.any_instance.stub(:save).and_return(false)
          post :create, {:list_owner => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_owner).should be_a_new(ListOwner)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListOwner.any_instance.stub(:save).and_return(false)
          post :create, {:list_owner => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested list_owner" do
          list_owner = ListOwner.create! valid_attributes
          # Assuming there are no other list_owners in the database, this
          # specifies that the ListOwner created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ListOwner.any_instance.should_receive(:update_attributes).with({ "list_id" => "1" })
          put :update, {:id => list_owner.to_param, :list_owner => { "list_id" => "1" }}, valid_session
        end

        it "assigns the requested list_owner as @list_owner" do
          list_owner = ListOwner.create! valid_attributes
          put :update, {:id => list_owner.to_param, :list_owner => valid_attributes}, valid_session
          assigns(:list_owner).should eq(list_owner)
        end

        it "redirects to the list_owner" do
          list_owner = ListOwner.create! valid_attributes
          put :update, {:id => list_owner.to_param, :list_owner => valid_attributes}, valid_session
          response.should redirect_to(list_owner)
        end
      end

      describe "with invalid params" do
        it "assigns the list_owner as @list_owner" do
          list_owner = ListOwner.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListOwner.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_owner.to_param, :list_owner => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_owner).should eq(list_owner)
        end

        it "re-renders the 'edit' template" do
          list_owner = ListOwner.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListOwner.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_owner.to_param, :list_owner => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested list_owner" do
        list_owner = ListOwner.create! valid_attributes
        expect {
          delete :destroy, {:id => list_owner.to_param}, valid_session
        }.to change(ListOwner, :count).by(-1)
      end

      it "redirects to the list_owners list" do
        list_owner = ListOwner.create! valid_attributes
        delete :destroy, {:id => list_owner.to_param}, valid_session
        response.should redirect_to(list_owners_url)
      end
    end

  end
end
