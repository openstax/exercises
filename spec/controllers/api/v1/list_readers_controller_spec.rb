require 'rails_helper'

module Api::V1
  RSpec.describe ListReadersController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # ListReader. As you add validations to ListReader, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "list_id" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ListReadersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all list_readers as @list_readers" do
        list_reader = ListReader.create! valid_attributes
        get :index, {}, valid_session
        assigns(:list_readers).should eq([list_reader])
      end
    end

    describe "GET show" do
      it "assigns the requested list_reader as @list_reader" do
        list_reader = ListReader.create! valid_attributes
        get :show, {:id => list_reader.to_param}, valid_session
        assigns(:list_reader).should eq(list_reader)
      end
    end

    describe "GET new" do
      it "assigns a new list_reader as @list_reader" do
        get :new, {}, valid_session
        assigns(:list_reader).should be_a_new(ListReader)
      end
    end

    describe "GET edit" do
      it "assigns the requested list_reader as @list_reader" do
        list_reader = ListReader.create! valid_attributes
        get :edit, {:id => list_reader.to_param}, valid_session
        assigns(:list_reader).should eq(list_reader)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ListReader" do
          expect {
            post :create, {:list_reader => valid_attributes}, valid_session
          }.to change(ListReader, :count).by(1)
        end

        it "assigns a newly created list_reader as @list_reader" do
          post :create, {:list_reader => valid_attributes}, valid_session
          assigns(:list_reader).should be_a(ListReader)
          assigns(:list_reader).should be_persisted
        end

        it "redirects to the created list_reader" do
          post :create, {:list_reader => valid_attributes}, valid_session
          response.should redirect_to(ListReader.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved list_reader as @list_reader" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListReader.any_instance.stub(:save).and_return(false)
          post :create, {:list_reader => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_reader).should be_a_new(ListReader)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListReader.any_instance.stub(:save).and_return(false)
          post :create, {:list_reader => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested list_reader" do
          list_reader = ListReader.create! valid_attributes
          # Assuming there are no other list_readers in the database, this
          # specifies that the ListReader created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ListReader.any_instance.should_receive(:update_attributes).with({ "list_id" => "1" })
          put :update, {:id => list_reader.to_param, :list_reader => { "list_id" => "1" }}, valid_session
        end

        it "assigns the requested list_reader as @list_reader" do
          list_reader = ListReader.create! valid_attributes
          put :update, {:id => list_reader.to_param, :list_reader => valid_attributes}, valid_session
          assigns(:list_reader).should eq(list_reader)
        end

        it "redirects to the list_reader" do
          list_reader = ListReader.create! valid_attributes
          put :update, {:id => list_reader.to_param, :list_reader => valid_attributes}, valid_session
          response.should redirect_to(list_reader)
        end
      end

      describe "with invalid params" do
        it "assigns the list_reader as @list_reader" do
          list_reader = ListReader.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListReader.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_reader.to_param, :list_reader => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_reader).should eq(list_reader)
        end

        it "re-renders the 'edit' template" do
          list_reader = ListReader.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListReader.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_reader.to_param, :list_reader => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested list_reader" do
        list_reader = ListReader.create! valid_attributes
        expect {
          delete :destroy, {:id => list_reader.to_param}, valid_session
        }.to change(ListReader, :count).by(-1)
      end

      it "redirects to the list_readers list" do
        list_reader = ListReader.create! valid_attributes
        delete :destroy, {:id => list_reader.to_param}, valid_session
        response.should redirect_to(list_readers_url)
      end
    end

  end
end
