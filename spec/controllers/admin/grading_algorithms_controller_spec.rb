require 'spec_helper'

module Admin
  describe GradingAlgorithmsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # GradingAlgorithm. As you add validations to GradingAlgorithm, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # GradingAlgorithmsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all grading_algorithms as @grading_algorithms" do
        grading_algorithm = GradingAlgorithm.create! valid_attributes
        get :index, {}, valid_session
        assigns(:grading_algorithms).should eq([grading_algorithm])
      end
    end

    describe "GET show" do
      it "assigns the requested grading_algorithm as @grading_algorithm" do
        grading_algorithm = GradingAlgorithm.create! valid_attributes
        get :show, {:id => grading_algorithm.to_param}, valid_session
        assigns(:grading_algorithm).should eq(grading_algorithm)
      end
    end

    describe "GET new" do
      it "assigns a new grading_algorithm as @grading_algorithm" do
        get :new, {}, valid_session
        assigns(:grading_algorithm).should be_a_new(GradingAlgorithm)
      end
    end

    describe "GET edit" do
      it "assigns the requested grading_algorithm as @grading_algorithm" do
        grading_algorithm = GradingAlgorithm.create! valid_attributes
        get :edit, {:id => grading_algorithm.to_param}, valid_session
        assigns(:grading_algorithm).should eq(grading_algorithm)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new GradingAlgorithm" do
          expect {
            post :create, {:grading_algorithm => valid_attributes}, valid_session
          }.to change(GradingAlgorithm, :count).by(1)
        end

        it "assigns a newly created grading_algorithm as @grading_algorithm" do
          post :create, {:grading_algorithm => valid_attributes}, valid_session
          assigns(:grading_algorithm).should be_a(GradingAlgorithm)
          assigns(:grading_algorithm).should be_persisted
        end

        it "redirects to the created grading_algorithm" do
          post :create, {:grading_algorithm => valid_attributes}, valid_session
          response.should redirect_to(GradingAlgorithm.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved grading_algorithm as @grading_algorithm" do
          # Trigger the behavior that occurs when invalid params are submitted
          GradingAlgorithm.any_instance.stub(:save).and_return(false)
          post :create, {:grading_algorithm => { "number" => "invalid value" }}, valid_session
          assigns(:grading_algorithm).should be_a_new(GradingAlgorithm)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          GradingAlgorithm.any_instance.stub(:save).and_return(false)
          post :create, {:grading_algorithm => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested grading_algorithm" do
          grading_algorithm = GradingAlgorithm.create! valid_attributes
          # Assuming there are no other grading_algorithms in the database, this
          # specifies that the GradingAlgorithm created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          GradingAlgorithm.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => grading_algorithm.to_param, :grading_algorithm => { "number" => "1" }}, valid_session
        end

        it "assigns the requested grading_algorithm as @grading_algorithm" do
          grading_algorithm = GradingAlgorithm.create! valid_attributes
          put :update, {:id => grading_algorithm.to_param, :grading_algorithm => valid_attributes}, valid_session
          assigns(:grading_algorithm).should eq(grading_algorithm)
        end

        it "redirects to the grading_algorithm" do
          grading_algorithm = GradingAlgorithm.create! valid_attributes
          put :update, {:id => grading_algorithm.to_param, :grading_algorithm => valid_attributes}, valid_session
          response.should redirect_to(grading_algorithm)
        end
      end

      describe "with invalid params" do
        it "assigns the grading_algorithm as @grading_algorithm" do
          grading_algorithm = GradingAlgorithm.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          GradingAlgorithm.any_instance.stub(:save).and_return(false)
          put :update, {:id => grading_algorithm.to_param, :grading_algorithm => { "number" => "invalid value" }}, valid_session
          assigns(:grading_algorithm).should eq(grading_algorithm)
        end

        it "re-renders the 'edit' template" do
          grading_algorithm = GradingAlgorithm.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          GradingAlgorithm.any_instance.stub(:save).and_return(false)
          put :update, {:id => grading_algorithm.to_param, :grading_algorithm => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested grading_algorithm" do
        grading_algorithm = GradingAlgorithm.create! valid_attributes
        expect {
          delete :destroy, {:id => grading_algorithm.to_param}, valid_session
        }.to change(GradingAlgorithm, :count).by(-1)
      end

      it "redirects to the grading_algorithms list" do
        grading_algorithm = GradingAlgorithm.create! valid_attributes
        delete :destroy, {:id => grading_algorithm.to_param}, valid_session
        response.should redirect_to(grading_algorithms_url)
      end
    end

  end
end
