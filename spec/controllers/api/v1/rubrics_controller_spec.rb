require 'spec_helper'

module Api::V1
  describe RubricsController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # Rubric. As you add validations to Rubric, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # RubricsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all rubrics as @rubrics" do
        rubric = Rubric.create! valid_attributes
        get :index, {}, valid_session
        assigns(:rubrics).should eq([rubric])
      end
    end

    describe "GET show" do
      it "assigns the requested rubric as @rubric" do
        rubric = Rubric.create! valid_attributes
        get :show, {:id => rubric.to_param}, valid_session
        assigns(:rubric).should eq(rubric)
      end
    end

    describe "GET new" do
      it "assigns a new rubric as @rubric" do
        get :new, {}, valid_session
        assigns(:rubric).should be_a_new(Rubric)
      end
    end

    describe "GET edit" do
      it "assigns the requested rubric as @rubric" do
        rubric = Rubric.create! valid_attributes
        get :edit, {:id => rubric.to_param}, valid_session
        assigns(:rubric).should eq(rubric)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Rubric" do
          expect {
            post :create, {:rubric => valid_attributes}, valid_session
          }.to change(Rubric, :count).by(1)
        end

        it "assigns a newly created rubric as @rubric" do
          post :create, {:rubric => valid_attributes}, valid_session
          assigns(:rubric).should be_a(Rubric)
          assigns(:rubric).should be_persisted
        end

        it "redirects to the created rubric" do
          post :create, {:rubric => valid_attributes}, valid_session
          response.should redirect_to(Rubric.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved rubric as @rubric" do
          # Trigger the behavior that occurs when invalid params are submitted
          Rubric.any_instance.stub(:save).and_return(false)
          post :create, {:rubric => { "number" => "invalid value" }}, valid_session
          assigns(:rubric).should be_a_new(Rubric)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Rubric.any_instance.stub(:save).and_return(false)
          post :create, {:rubric => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested rubric" do
          rubric = Rubric.create! valid_attributes
          # Assuming there are no other rubrics in the database, this
          # specifies that the Rubric created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Rubric.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => rubric.to_param, :rubric => { "number" => "1" }}, valid_session
        end

        it "assigns the requested rubric as @rubric" do
          rubric = Rubric.create! valid_attributes
          put :update, {:id => rubric.to_param, :rubric => valid_attributes}, valid_session
          assigns(:rubric).should eq(rubric)
        end

        it "redirects to the rubric" do
          rubric = Rubric.create! valid_attributes
          put :update, {:id => rubric.to_param, :rubric => valid_attributes}, valid_session
          response.should redirect_to(rubric)
        end
      end

      describe "with invalid params" do
        it "assigns the rubric as @rubric" do
          rubric = Rubric.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Rubric.any_instance.stub(:save).and_return(false)
          put :update, {:id => rubric.to_param, :rubric => { "number" => "invalid value" }}, valid_session
          assigns(:rubric).should eq(rubric)
        end

        it "re-renders the 'edit' template" do
          rubric = Rubric.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Rubric.any_instance.stub(:save).and_return(false)
          put :update, {:id => rubric.to_param, :rubric => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested rubric" do
        rubric = Rubric.create! valid_attributes
        expect {
          delete :destroy, {:id => rubric.to_param}, valid_session
        }.to change(Rubric, :count).by(-1)
      end

      it "redirects to the rubrics list" do
        rubric = Rubric.create! valid_attributes
        delete :destroy, {:id => rubric.to_param}, valid_session
        response.should redirect_to(rubrics_url)
      end
    end

  end
end
