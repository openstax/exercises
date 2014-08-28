require 'rails_helper'

module Api::V1
  RSpec.describe PartSupportsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # PartSupport. As you add validations to PartSupport, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PartSupportsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all part_supports as @part_supports" do
        part_support = PartSupport.create! valid_attributes
        get :index, {}, valid_session
        assigns(:part_supports).should eq([part_support])
      end
    end

    describe "GET show" do
      it "assigns the requested part_support as @part_support" do
        part_support = PartSupport.create! valid_attributes
        get :show, {:id => part_support.to_param}, valid_session
        assigns(:part_support).should eq(part_support)
      end
    end

    describe "GET new" do
      it "assigns a new part_support as @part_support" do
        get :new, {}, valid_session
        assigns(:part_support).should be_a_new(PartSupport)
      end
    end

    describe "GET edit" do
      it "assigns the requested part_support as @part_support" do
        part_support = PartSupport.create! valid_attributes
        get :edit, {:id => part_support.to_param}, valid_session
        assigns(:part_support).should eq(part_support)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new PartSupport" do
          expect {
            post :create, {:part_support => valid_attributes}, valid_session
          }.to change(PartSupport, :count).by(1)
        end

        it "assigns a newly created part_support as @part_support" do
          post :create, {:part_support => valid_attributes}, valid_session
          assigns(:part_support).should be_a(PartSupport)
          assigns(:part_support).should be_persisted
        end

        it "redirects to the created part_support" do
          post :create, {:part_support => valid_attributes}, valid_session
          response.should redirect_to(PartSupport.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved part_support as @part_support" do
          # Trigger the behavior that occurs when invalid params are submitted
          PartSupport.any_instance.stub(:save).and_return(false)
          post :create, {:part_support => { "number" => "invalid value" }}, valid_session
          assigns(:part_support).should be_a_new(PartSupport)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          PartSupport.any_instance.stub(:save).and_return(false)
          post :create, {:part_support => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested part_support" do
          part_support = PartSupport.create! valid_attributes
          # Assuming there are no other part_supports in the database, this
          # specifies that the PartSupport created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          PartSupport.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => part_support.to_param, :part_support => { "number" => "1" }}, valid_session
        end

        it "assigns the requested part_support as @part_support" do
          part_support = PartSupport.create! valid_attributes
          put :update, {:id => part_support.to_param, :part_support => valid_attributes}, valid_session
          assigns(:part_support).should eq(part_support)
        end

        it "redirects to the part_support" do
          part_support = PartSupport.create! valid_attributes
          put :update, {:id => part_support.to_param, :part_support => valid_attributes}, valid_session
          response.should redirect_to(part_support)
        end
      end

      describe "with invalid params" do
        it "assigns the part_support as @part_support" do
          part_support = PartSupport.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          PartSupport.any_instance.stub(:save).and_return(false)
          put :update, {:id => part_support.to_param, :part_support => { "number" => "invalid value" }}, valid_session
          assigns(:part_support).should eq(part_support)
        end

        it "re-renders the 'edit' template" do
          part_support = PartSupport.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          PartSupport.any_instance.stub(:save).and_return(false)
          put :update, {:id => part_support.to_param, :part_support => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested part_support" do
        part_support = PartSupport.create! valid_attributes
        expect {
          delete :destroy, {:id => part_support.to_param}, valid_session
        }.to change(PartSupport, :count).by(-1)
      end

      it "redirects to the part_supports list" do
        part_support = PartSupport.create! valid_attributes
        delete :destroy, {:id => part_support.to_param}, valid_session
        response.should redirect_to(part_supports_url)
      end
    end

  end
end
