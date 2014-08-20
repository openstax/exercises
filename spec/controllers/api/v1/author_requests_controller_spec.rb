require 'spec_helper'

module Api::V1
  describe AuthorRequestsController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # AuthorRequest. As you add validations to AuthorRequest, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # AuthorRequestsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all author_requests as @author_requests" do
        author_request = AuthorRequest.create! valid_attributes
        get :index, {}, valid_session
        assigns(:author_requests).should eq([author_request])
      end
    end

    describe "GET show" do
      it "assigns the requested author_request as @author_request" do
        author_request = AuthorRequest.create! valid_attributes
        get :show, {:id => author_request.to_param}, valid_session
        assigns(:author_request).should eq(author_request)
      end
    end

    describe "GET new" do
      it "assigns a new author_request as @author_request" do
        get :new, {}, valid_session
        assigns(:author_request).should be_a_new(AuthorRequest)
      end
    end

    describe "GET edit" do
      it "assigns the requested author_request as @author_request" do
        author_request = AuthorRequest.create! valid_attributes
        get :edit, {:id => author_request.to_param}, valid_session
        assigns(:author_request).should eq(author_request)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new AuthorRequest" do
          expect {
            post :create, {:author_request => valid_attributes}, valid_session
          }.to change(AuthorRequest, :count).by(1)
        end

        it "assigns a newly created author_request as @author_request" do
          post :create, {:author_request => valid_attributes}, valid_session
          assigns(:author_request).should be_a(AuthorRequest)
          assigns(:author_request).should be_persisted
        end

        it "redirects to the created author_request" do
          post :create, {:author_request => valid_attributes}, valid_session
          response.should redirect_to(AuthorRequest.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved author_request as @author_request" do
          # Trigger the behavior that occurs when invalid params are submitted
          AuthorRequest.any_instance.stub(:save).and_return(false)
          post :create, {:author_request => { "number" => "invalid value" }}, valid_session
          assigns(:author_request).should be_a_new(AuthorRequest)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          AuthorRequest.any_instance.stub(:save).and_return(false)
          post :create, {:author_request => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested author_request" do
          author_request = AuthorRequest.create! valid_attributes
          # Assuming there are no other author_requests in the database, this
          # specifies that the AuthorRequest created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          AuthorRequest.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => author_request.to_param, :author_request => { "number" => "1" }}, valid_session
        end

        it "assigns the requested author_request as @author_request" do
          author_request = AuthorRequest.create! valid_attributes
          put :update, {:id => author_request.to_param, :author_request => valid_attributes}, valid_session
          assigns(:author_request).should eq(author_request)
        end

        it "redirects to the author_request" do
          author_request = AuthorRequest.create! valid_attributes
          put :update, {:id => author_request.to_param, :author_request => valid_attributes}, valid_session
          response.should redirect_to(author_request)
        end
      end

      describe "with invalid params" do
        it "assigns the author_request as @author_request" do
          author_request = AuthorRequest.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          AuthorRequest.any_instance.stub(:save).and_return(false)
          put :update, {:id => author_request.to_param, :author_request => { "number" => "invalid value" }}, valid_session
          assigns(:author_request).should eq(author_request)
        end

        it "re-renders the 'edit' template" do
          author_request = AuthorRequest.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          AuthorRequest.any_instance.stub(:save).and_return(false)
          put :update, {:id => author_request.to_param, :author_request => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested author_request" do
        author_request = AuthorRequest.create! valid_attributes
        expect {
          delete :destroy, {:id => author_request.to_param}, valid_session
        }.to change(AuthorRequest, :count).by(-1)
      end

      it "redirects to the author_requests list" do
        author_request = AuthorRequest.create! valid_attributes
        delete :destroy, {:id => author_request.to_param}, valid_session
        response.should redirect_to(author_requests_url)
      end
    end

  end
end
