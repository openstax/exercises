require 'rails_helper'

module Api::V1
  RSpec.describe CopyrightHolderRequestsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # CopyrightHolderRequest. As you add validations to CopyrightHolderRequest, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # CopyrightHolderRequestsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all copyright_holder_requests as @copyright_holder_requests" do
        copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
        get :index, {}, valid_session
        assigns(:copyright_holder_requests).should eq([copyright_holder_request])
      end
    end

    describe "GET show" do
      it "assigns the requested copyright_holder_request as @copyright_holder_request" do
        copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
        get :show, {:id => copyright_holder_request.to_param}, valid_session
        assigns(:copyright_holder_request).should eq(copyright_holder_request)
      end
    end

    describe "GET new" do
      it "assigns a new copyright_holder_request as @copyright_holder_request" do
        get :new, {}, valid_session
        assigns(:copyright_holder_request).should be_a_new(CopyrightHolderRequest)
      end
    end

    describe "GET edit" do
      it "assigns the requested copyright_holder_request as @copyright_holder_request" do
        copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
        get :edit, {:id => copyright_holder_request.to_param}, valid_session
        assigns(:copyright_holder_request).should eq(copyright_holder_request)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new CopyrightHolderRequest" do
          expect {
            post :create, {:copyright_holder_request => valid_attributes}, valid_session
          }.to change(CopyrightHolderRequest, :count).by(1)
        end

        it "assigns a newly created copyright_holder_request as @copyright_holder_request" do
          post :create, {:copyright_holder_request => valid_attributes}, valid_session
          assigns(:copyright_holder_request).should be_a(CopyrightHolderRequest)
          assigns(:copyright_holder_request).should be_persisted
        end

        it "redirects to the created copyright_holder_request" do
          post :create, {:copyright_holder_request => valid_attributes}, valid_session
          response.should redirect_to(CopyrightHolderRequest.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved copyright_holder_request as @copyright_holder_request" do
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolderRequest.any_instance.stub(:save).and_return(false)
          post :create, {:copyright_holder_request => { "number" => "invalid value" }}, valid_session
          assigns(:copyright_holder_request).should be_a_new(CopyrightHolderRequest)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolderRequest.any_instance.stub(:save).and_return(false)
          post :create, {:copyright_holder_request => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested copyright_holder_request" do
          copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
          # Assuming there are no other copyright_holder_requests in the database, this
          # specifies that the CopyrightHolderRequest created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          CopyrightHolderRequest.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => copyright_holder_request.to_param, :copyright_holder_request => { "number" => "1" }}, valid_session
        end

        it "assigns the requested copyright_holder_request as @copyright_holder_request" do
          copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
          put :update, {:id => copyright_holder_request.to_param, :copyright_holder_request => valid_attributes}, valid_session
          assigns(:copyright_holder_request).should eq(copyright_holder_request)
        end

        it "redirects to the copyright_holder_request" do
          copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
          put :update, {:id => copyright_holder_request.to_param, :copyright_holder_request => valid_attributes}, valid_session
          response.should redirect_to(copyright_holder_request)
        end
      end

      describe "with invalid params" do
        it "assigns the copyright_holder_request as @copyright_holder_request" do
          copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolderRequest.any_instance.stub(:save).and_return(false)
          put :update, {:id => copyright_holder_request.to_param, :copyright_holder_request => { "number" => "invalid value" }}, valid_session
          assigns(:copyright_holder_request).should eq(copyright_holder_request)
        end

        it "re-renders the 'edit' template" do
          copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolderRequest.any_instance.stub(:save).and_return(false)
          put :update, {:id => copyright_holder_request.to_param, :copyright_holder_request => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested copyright_holder_request" do
        copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
        expect {
          delete :destroy, {:id => copyright_holder_request.to_param}, valid_session
        }.to change(CopyrightHolderRequest, :count).by(-1)
      end

      it "redirects to the copyright_holder_requests list" do
        copyright_holder_request = CopyrightHolderRequest.create! valid_attributes
        delete :destroy, {:id => copyright_holder_request.to_param}, valid_session
        response.should redirect_to(copyright_holder_requests_url)
      end
    end

  end
end
