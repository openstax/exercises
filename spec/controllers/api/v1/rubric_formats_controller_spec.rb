require 'rails_helper'

module Api::V1
  describe RubricFormatsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # RubricFormat. As you add validations to RubricFormat, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # RubricFormatsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all rubric_formats as @rubric_formats" do
        rubric_format = RubricFormat.create! valid_attributes
        get :index, {}, valid_session
        assigns(:rubric_formats).should eq([rubric_format])
      end
    end

    describe "GET show" do
      it "assigns the requested rubric_format as @rubric_format" do
        rubric_format = RubricFormat.create! valid_attributes
        get :show, {:id => rubric_format.to_param}, valid_session
        assigns(:rubric_format).should eq(rubric_format)
      end
    end

    describe "GET new" do
      it "assigns a new rubric_format as @rubric_format" do
        get :new, {}, valid_session
        assigns(:rubric_format).should be_a_new(RubricFormat)
      end
    end

    describe "GET edit" do
      it "assigns the requested rubric_format as @rubric_format" do
        rubric_format = RubricFormat.create! valid_attributes
        get :edit, {:id => rubric_format.to_param}, valid_session
        assigns(:rubric_format).should eq(rubric_format)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new RubricFormat" do
          expect {
            post :create, {:rubric_format => valid_attributes}, valid_session
          }.to change(RubricFormat, :count).by(1)
        end

        it "assigns a newly created rubric_format as @rubric_format" do
          post :create, {:rubric_format => valid_attributes}, valid_session
          assigns(:rubric_format).should be_a(RubricFormat)
          assigns(:rubric_format).should be_persisted
        end

        it "redirects to the created rubric_format" do
          post :create, {:rubric_format => valid_attributes}, valid_session
          response.should redirect_to(RubricFormat.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved rubric_format as @rubric_format" do
          # Trigger the behavior that occurs when invalid params are submitted
          RubricFormat.any_instance.stub(:save).and_return(false)
          post :create, {:rubric_format => { "number" => "invalid value" }}, valid_session
          assigns(:rubric_format).should be_a_new(RubricFormat)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          RubricFormat.any_instance.stub(:save).and_return(false)
          post :create, {:rubric_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested rubric_format" do
          rubric_format = RubricFormat.create! valid_attributes
          # Assuming there are no other rubric_formats in the database, this
          # specifies that the RubricFormat created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          RubricFormat.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => rubric_format.to_param, :rubric_format => { "number" => "1" }}, valid_session
        end

        it "assigns the requested rubric_format as @rubric_format" do
          rubric_format = RubricFormat.create! valid_attributes
          put :update, {:id => rubric_format.to_param, :rubric_format => valid_attributes}, valid_session
          assigns(:rubric_format).should eq(rubric_format)
        end

        it "redirects to the rubric_format" do
          rubric_format = RubricFormat.create! valid_attributes
          put :update, {:id => rubric_format.to_param, :rubric_format => valid_attributes}, valid_session
          response.should redirect_to(rubric_format)
        end
      end

      describe "with invalid params" do
        it "assigns the rubric_format as @rubric_format" do
          rubric_format = RubricFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          RubricFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => rubric_format.to_param, :rubric_format => { "number" => "invalid value" }}, valid_session
          assigns(:rubric_format).should eq(rubric_format)
        end

        it "re-renders the 'edit' template" do
          rubric_format = RubricFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          RubricFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => rubric_format.to_param, :rubric_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested rubric_format" do
        rubric_format = RubricFormat.create! valid_attributes
        expect {
          delete :destroy, {:id => rubric_format.to_param}, valid_session
        }.to change(RubricFormat, :count).by(-1)
      end

      it "redirects to the rubric_formats list" do
        rubric_format = RubricFormat.create! valid_attributes
        delete :destroy, {:id => rubric_format.to_param}, valid_session
        response.should redirect_to(rubric_formats_url)
      end
    end

  end
end
