require 'rails_helper'

module Api::V1
  describe QuestionFormatsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # QuestionFormat. As you add validations to QuestionFormat, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # QuestionFormatsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all question_formats as @question_formats" do
        question_format = QuestionFormat.create! valid_attributes
        get :index, {}, valid_session
        assigns(:question_formats).should eq([question_format])
      end
    end

    describe "GET show" do
      it "assigns the requested question_format as @question_format" do
        question_format = QuestionFormat.create! valid_attributes
        get :show, {:id => question_format.to_param}, valid_session
        assigns(:question_format).should eq(question_format)
      end
    end

    describe "GET new" do
      it "assigns a new question_format as @question_format" do
        get :new, {}, valid_session
        assigns(:question_format).should be_a_new(QuestionFormat)
      end
    end

    describe "GET edit" do
      it "assigns the requested question_format as @question_format" do
        question_format = QuestionFormat.create! valid_attributes
        get :edit, {:id => question_format.to_param}, valid_session
        assigns(:question_format).should eq(question_format)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new QuestionFormat" do
          expect {
            post :create, {:question_format => valid_attributes}, valid_session
          }.to change(QuestionFormat, :count).by(1)
        end

        it "assigns a newly created question_format as @question_format" do
          post :create, {:question_format => valid_attributes}, valid_session
          assigns(:question_format).should be_a(QuestionFormat)
          assigns(:question_format).should be_persisted
        end

        it "redirects to the created question_format" do
          post :create, {:question_format => valid_attributes}, valid_session
          response.should redirect_to(QuestionFormat.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved question_format as @question_format" do
          # Trigger the behavior that occurs when invalid params are submitted
          QuestionFormat.any_instance.stub(:save).and_return(false)
          post :create, {:question_format => { "number" => "invalid value" }}, valid_session
          assigns(:question_format).should be_a_new(QuestionFormat)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          QuestionFormat.any_instance.stub(:save).and_return(false)
          post :create, {:question_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested question_format" do
          question_format = QuestionFormat.create! valid_attributes
          # Assuming there are no other question_formats in the database, this
          # specifies that the QuestionFormat created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          QuestionFormat.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => question_format.to_param, :question_format => { "number" => "1" }}, valid_session
        end

        it "assigns the requested question_format as @question_format" do
          question_format = QuestionFormat.create! valid_attributes
          put :update, {:id => question_format.to_param, :question_format => valid_attributes}, valid_session
          assigns(:question_format).should eq(question_format)
        end

        it "redirects to the question_format" do
          question_format = QuestionFormat.create! valid_attributes
          put :update, {:id => question_format.to_param, :question_format => valid_attributes}, valid_session
          response.should redirect_to(question_format)
        end
      end

      describe "with invalid params" do
        it "assigns the question_format as @question_format" do
          question_format = QuestionFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          QuestionFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => question_format.to_param, :question_format => { "number" => "invalid value" }}, valid_session
          assigns(:question_format).should eq(question_format)
        end

        it "re-renders the 'edit' template" do
          question_format = QuestionFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          QuestionFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => question_format.to_param, :question_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested question_format" do
        question_format = QuestionFormat.create! valid_attributes
        expect {
          delete :destroy, {:id => question_format.to_param}, valid_session
        }.to change(QuestionFormat, :count).by(-1)
      end

      it "redirects to the question_formats list" do
        question_format = QuestionFormat.create! valid_attributes
        delete :destroy, {:id => question_format.to_param}, valid_session
        response.should redirect_to(question_formats_url)
      end
    end

  end
end
