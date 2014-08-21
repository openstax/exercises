require 'rails_helper'

module Api::V1
  describe ListExercisesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # ListExercise. As you add validations to ListExercise, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "list_id" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ListExercisesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all list_exercises as @list_exercises" do
        list_exercise = ListExercise.create! valid_attributes
        get :index, {}, valid_session
        assigns(:list_exercises).should eq([list_exercise])
      end
    end

    describe "GET show" do
      it "assigns the requested list_exercise as @list_exercise" do
        list_exercise = ListExercise.create! valid_attributes
        get :show, {:id => list_exercise.to_param}, valid_session
        assigns(:list_exercise).should eq(list_exercise)
      end
    end

    describe "GET new" do
      it "assigns a new list_exercise as @list_exercise" do
        get :new, {}, valid_session
        assigns(:list_exercise).should be_a_new(ListExercise)
      end
    end

    describe "GET edit" do
      it "assigns the requested list_exercise as @list_exercise" do
        list_exercise = ListExercise.create! valid_attributes
        get :edit, {:id => list_exercise.to_param}, valid_session
        assigns(:list_exercise).should eq(list_exercise)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ListExercise" do
          expect {
            post :create, {:list_exercise => valid_attributes}, valid_session
          }.to change(ListExercise, :count).by(1)
        end

        it "assigns a newly created list_exercise as @list_exercise" do
          post :create, {:list_exercise => valid_attributes}, valid_session
          assigns(:list_exercise).should be_a(ListExercise)
          assigns(:list_exercise).should be_persisted
        end

        it "redirects to the created list_exercise" do
          post :create, {:list_exercise => valid_attributes}, valid_session
          response.should redirect_to(ListExercise.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved list_exercise as @list_exercise" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListExercise.any_instance.stub(:save).and_return(false)
          post :create, {:list_exercise => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_exercise).should be_a_new(ListExercise)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ListExercise.any_instance.stub(:save).and_return(false)
          post :create, {:list_exercise => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested list_exercise" do
          list_exercise = ListExercise.create! valid_attributes
          # Assuming there are no other list_exercises in the database, this
          # specifies that the ListExercise created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ListExercise.any_instance.should_receive(:update_attributes).with({ "list_id" => "1" })
          put :update, {:id => list_exercise.to_param, :list_exercise => { "list_id" => "1" }}, valid_session
        end

        it "assigns the requested list_exercise as @list_exercise" do
          list_exercise = ListExercise.create! valid_attributes
          put :update, {:id => list_exercise.to_param, :list_exercise => valid_attributes}, valid_session
          assigns(:list_exercise).should eq(list_exercise)
        end

        it "redirects to the list_exercise" do
          list_exercise = ListExercise.create! valid_attributes
          put :update, {:id => list_exercise.to_param, :list_exercise => valid_attributes}, valid_session
          response.should redirect_to(list_exercise)
        end
      end

      describe "with invalid params" do
        it "assigns the list_exercise as @list_exercise" do
          list_exercise = ListExercise.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListExercise.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_exercise.to_param, :list_exercise => { "list_id" => "invalid value" }}, valid_session
          assigns(:list_exercise).should eq(list_exercise)
        end

        it "re-renders the 'edit' template" do
          list_exercise = ListExercise.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ListExercise.any_instance.stub(:save).and_return(false)
          put :update, {:id => list_exercise.to_param, :list_exercise => { "list_id" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested list_exercise" do
        list_exercise = ListExercise.create! valid_attributes
        expect {
          delete :destroy, {:id => list_exercise.to_param}, valid_session
        }.to change(ListExercise, :count).by(-1)
      end

      it "redirects to the list_exercises list" do
        list_exercise = ListExercise.create! valid_attributes
        delete :destroy, {:id => list_exercise.to_param}, valid_session
        response.should redirect_to(list_exercises_url)
      end
    end

  end
end
