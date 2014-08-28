require "rails_helper"

module Api::V1
  RSpec.describe AttachmentsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Attachment. As you add validations to Attachment, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # AttachmentsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all attachments as @attachments" do
        attachment = Attachment.create! valid_attributes
        get :index, {}, valid_session
        assigns(:attachments).should eq([attachment])
      end
    end

    describe "GET show" do
      it "assigns the requested attachment as @attachment" do
        attachment = Attachment.create! valid_attributes
        get :show, {:id => attachment.to_param}, valid_session
        assigns(:attachment).should eq(attachment)
      end
    end

    describe "GET new" do
      it "assigns a new attachment as @attachment" do
        get :new, {}, valid_session
        assigns(:attachment).should be_a_new(Attachment)
      end
    end

    describe "GET edit" do
      it "assigns the requested attachment as @attachment" do
        attachment = Attachment.create! valid_attributes
        get :edit, {:id => attachment.to_param}, valid_session
        assigns(:attachment).should eq(attachment)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Attachment" do
          expect {
            post :create, {:attachment => valid_attributes}, valid_session
          }.to change(Attachment, :count).by(1)
        end

        it "assigns a newly created attachment as @attachment" do
          post :create, {:attachment => valid_attributes}, valid_session
          assigns(:attachment).should be_a(Attachment)
          assigns(:attachment).should be_persisted
        end

        it "redirects to the created attachment" do
          post :create, {:attachment => valid_attributes}, valid_session
          response.should redirect_to(Attachment.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved attachment as @attachment" do
          # Trigger the behavior that occurs when invalid params are submitted
          Attachment.any_instance.stub(:save).and_return(false)
          post :create, {:attachment => { "number" => "invalid value" }}, valid_session
          assigns(:attachment).should be_a_new(Attachment)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Attachment.any_instance.stub(:save).and_return(false)
          post :create, {:attachment => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested attachment" do
          attachment = Attachment.create! valid_attributes
          # Assuming there are no other attachments in the database, this
          # specifies that the Attachment created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Attachment.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => attachment.to_param, :attachment => { "number" => "1" }}, valid_session
        end

        it "assigns the requested attachment as @attachment" do
          attachment = Attachment.create! valid_attributes
          put :update, {:id => attachment.to_param, :attachment => valid_attributes}, valid_session
          assigns(:attachment).should eq(attachment)
        end

        it "redirects to the attachment" do
          attachment = Attachment.create! valid_attributes
          put :update, {:id => attachment.to_param, :attachment => valid_attributes}, valid_session
          response.should redirect_to(attachment)
        end
      end

      describe "with invalid params" do
        it "assigns the attachment as @attachment" do
          attachment = Attachment.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Attachment.any_instance.stub(:save).and_return(false)
          put :update, {:id => attachment.to_param, :attachment => { "number" => "invalid value" }}, valid_session
          assigns(:attachment).should eq(attachment)
        end

        it "re-renders the 'edit' template" do
          attachment = Attachment.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Attachment.any_instance.stub(:save).and_return(false)
          put :update, {:id => attachment.to_param, :attachment => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested attachment" do
        attachment = Attachment.create! valid_attributes
        expect {
          delete :destroy, {:id => attachment.to_param}, valid_session
        }.to change(Attachment, :count).by(-1)
      end

      it "redirects to the attachments list" do
        attachment = Attachment.create! valid_attributes
        delete :destroy, {:id => attachment.to_param}, valid_session
        response.should redirect_to(attachments_url)
      end
    end

  end
end
