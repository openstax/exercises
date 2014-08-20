require 'spec_helper'

module Api::V1
  describe UploadsController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # Upload. As you add validations to Upload, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # UploadsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all uploads as @uploads" do
        upload = Upload.create! valid_attributes
        get :index, {}, valid_session
        assigns(:uploads).should eq([upload])
      end
    end

    describe "GET show" do
      it "assigns the requested upload as @upload" do
        upload = Upload.create! valid_attributes
        get :show, {:id => upload.to_param}, valid_session
        assigns(:upload).should eq(upload)
      end
    end

    describe "GET new" do
      it "assigns a new upload as @upload" do
        get :new, {}, valid_session
        assigns(:upload).should be_a_new(Upload)
      end
    end

    describe "GET edit" do
      it "assigns the requested upload as @upload" do
        upload = Upload.create! valid_attributes
        get :edit, {:id => upload.to_param}, valid_session
        assigns(:upload).should eq(upload)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Upload" do
          expect {
            post :create, {:upload => valid_attributes}, valid_session
          }.to change(Upload, :count).by(1)
        end

        it "assigns a newly created upload as @upload" do
          post :create, {:upload => valid_attributes}, valid_session
          assigns(:upload).should be_a(Upload)
          assigns(:upload).should be_persisted
        end

        it "redirects to the created upload" do
          post :create, {:upload => valid_attributes}, valid_session
          response.should redirect_to(Upload.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved upload as @upload" do
          # Trigger the behavior that occurs when invalid params are submitted
          Upload.any_instance.stub(:save).and_return(false)
          post :create, {:upload => { "number" => "invalid value" }}, valid_session
          assigns(:upload).should be_a_new(Upload)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Upload.any_instance.stub(:save).and_return(false)
          post :create, {:upload => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested upload" do
          upload = Upload.create! valid_attributes
          # Assuming there are no other uploads in the database, this
          # specifies that the Upload created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Upload.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => upload.to_param, :upload => { "number" => "1" }}, valid_session
        end

        it "assigns the requested upload as @upload" do
          upload = Upload.create! valid_attributes
          put :update, {:id => upload.to_param, :upload => valid_attributes}, valid_session
          assigns(:upload).should eq(upload)
        end

        it "redirects to the upload" do
          upload = Upload.create! valid_attributes
          put :update, {:id => upload.to_param, :upload => valid_attributes}, valid_session
          response.should redirect_to(upload)
        end
      end

      describe "with invalid params" do
        it "assigns the upload as @upload" do
          upload = Upload.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Upload.any_instance.stub(:save).and_return(false)
          put :update, {:id => upload.to_param, :upload => { "number" => "invalid value" }}, valid_session
          assigns(:upload).should eq(upload)
        end

        it "re-renders the 'edit' template" do
          upload = Upload.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Upload.any_instance.stub(:save).and_return(false)
          put :update, {:id => upload.to_param, :upload => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested upload" do
        upload = Upload.create! valid_attributes
        expect {
          delete :destroy, {:id => upload.to_param}, valid_session
        }.to change(Upload, :count).by(-1)
      end

      it "redirects to the uploads list" do
        upload = Upload.create! valid_attributes
        delete :destroy, {:id => upload.to_param}, valid_session
        response.should redirect_to(uploads_url)
      end
    end

  end
end
