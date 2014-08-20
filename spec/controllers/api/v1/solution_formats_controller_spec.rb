require 'spec_helper'

module Api::V1
  describe SolutionFormatsController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # SolutionFormat. As you add validations to SolutionFormat, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # SolutionFormatsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all solution_formats as @solution_formats" do
        solution_format = SolutionFormat.create! valid_attributes
        get :index, {}, valid_session
        assigns(:solution_formats).should eq([solution_format])
      end
    end

    describe "GET show" do
      it "assigns the requested solution_format as @solution_format" do
        solution_format = SolutionFormat.create! valid_attributes
        get :show, {:id => solution_format.to_param}, valid_session
        assigns(:solution_format).should eq(solution_format)
      end
    end

    describe "GET new" do
      it "assigns a new solution_format as @solution_format" do
        get :new, {}, valid_session
        assigns(:solution_format).should be_a_new(SolutionFormat)
      end
    end

    describe "GET edit" do
      it "assigns the requested solution_format as @solution_format" do
        solution_format = SolutionFormat.create! valid_attributes
        get :edit, {:id => solution_format.to_param}, valid_session
        assigns(:solution_format).should eq(solution_format)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new SolutionFormat" do
          expect {
            post :create, {:solution_format => valid_attributes}, valid_session
          }.to change(SolutionFormat, :count).by(1)
        end

        it "assigns a newly created solution_format as @solution_format" do
          post :create, {:solution_format => valid_attributes}, valid_session
          assigns(:solution_format).should be_a(SolutionFormat)
          assigns(:solution_format).should be_persisted
        end

        it "redirects to the created solution_format" do
          post :create, {:solution_format => valid_attributes}, valid_session
          response.should redirect_to(SolutionFormat.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved solution_format as @solution_format" do
          # Trigger the behavior that occurs when invalid params are submitted
          SolutionFormat.any_instance.stub(:save).and_return(false)
          post :create, {:solution_format => { "number" => "invalid value" }}, valid_session
          assigns(:solution_format).should be_a_new(SolutionFormat)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          SolutionFormat.any_instance.stub(:save).and_return(false)
          post :create, {:solution_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested solution_format" do
          solution_format = SolutionFormat.create! valid_attributes
          # Assuming there are no other solution_formats in the database, this
          # specifies that the SolutionFormat created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          SolutionFormat.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => solution_format.to_param, :solution_format => { "number" => "1" }}, valid_session
        end

        it "assigns the requested solution_format as @solution_format" do
          solution_format = SolutionFormat.create! valid_attributes
          put :update, {:id => solution_format.to_param, :solution_format => valid_attributes}, valid_session
          assigns(:solution_format).should eq(solution_format)
        end

        it "redirects to the solution_format" do
          solution_format = SolutionFormat.create! valid_attributes
          put :update, {:id => solution_format.to_param, :solution_format => valid_attributes}, valid_session
          response.should redirect_to(solution_format)
        end
      end

      describe "with invalid params" do
        it "assigns the solution_format as @solution_format" do
          solution_format = SolutionFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          SolutionFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => solution_format.to_param, :solution_format => { "number" => "invalid value" }}, valid_session
          assigns(:solution_format).should eq(solution_format)
        end

        it "re-renders the 'edit' template" do
          solution_format = SolutionFormat.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          SolutionFormat.any_instance.stub(:save).and_return(false)
          put :update, {:id => solution_format.to_param, :solution_format => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested solution_format" do
        solution_format = SolutionFormat.create! valid_attributes
        expect {
          delete :destroy, {:id => solution_format.to_param}, valid_session
        }.to change(SolutionFormat, :count).by(-1)
      end

      it "redirects to the solution_formats list" do
        solution_format = SolutionFormat.create! valid_attributes
        delete :destroy, {:id => solution_format.to_param}, valid_session
        response.should redirect_to(solution_formats_url)
      end
    end

  end
end
