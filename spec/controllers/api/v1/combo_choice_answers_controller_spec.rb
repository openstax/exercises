require 'spec_helper'

module Api::V1
  describe ComboChoiceAnswersController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # ComboChoiceAnswer. As you add validations to ComboChoiceAnswer, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ComboChoiceAnswersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all combo_choice_answers as @combo_choice_answers" do
        combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
        get :index, {}, valid_session
        assigns(:combo_choice_answers).should eq([combo_choice_answer])
      end
    end

    describe "GET show" do
      it "assigns the requested combo_choice_answer as @combo_choice_answer" do
        combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
        get :show, {:id => combo_choice_answer.to_param}, valid_session
        assigns(:combo_choice_answer).should eq(combo_choice_answer)
      end
    end

    describe "GET new" do
      it "assigns a new combo_choice_answer as @combo_choice_answer" do
        get :new, {}, valid_session
        assigns(:combo_choice_answer).should be_a_new(ComboChoiceAnswer)
      end
    end

    describe "GET edit" do
      it "assigns the requested combo_choice_answer as @combo_choice_answer" do
        combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
        get :edit, {:id => combo_choice_answer.to_param}, valid_session
        assigns(:combo_choice_answer).should eq(combo_choice_answer)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ComboChoiceAnswer" do
          expect {
            post :create, {:combo_choice_answer => valid_attributes}, valid_session
          }.to change(ComboChoiceAnswer, :count).by(1)
        end

        it "assigns a newly created combo_choice_answer as @combo_choice_answer" do
          post :create, {:combo_choice_answer => valid_attributes}, valid_session
          assigns(:combo_choice_answer).should be_a(ComboChoiceAnswer)
          assigns(:combo_choice_answer).should be_persisted
        end

        it "redirects to the created combo_choice_answer" do
          post :create, {:combo_choice_answer => valid_attributes}, valid_session
          response.should redirect_to(ComboChoiceAnswer.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved combo_choice_answer as @combo_choice_answer" do
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoiceAnswer.any_instance.stub(:save).and_return(false)
          post :create, {:combo_choice_answer => { "number" => "invalid value" }}, valid_session
          assigns(:combo_choice_answer).should be_a_new(ComboChoiceAnswer)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoiceAnswer.any_instance.stub(:save).and_return(false)
          post :create, {:combo_choice_answer => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested combo_choice_answer" do
          combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
          # Assuming there are no other combo_choice_answers in the database, this
          # specifies that the ComboChoiceAnswer created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ComboChoiceAnswer.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => combo_choice_answer.to_param, :combo_choice_answer => { "number" => "1" }}, valid_session
        end

        it "assigns the requested combo_choice_answer as @combo_choice_answer" do
          combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
          put :update, {:id => combo_choice_answer.to_param, :combo_choice_answer => valid_attributes}, valid_session
          assigns(:combo_choice_answer).should eq(combo_choice_answer)
        end

        it "redirects to the combo_choice_answer" do
          combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
          put :update, {:id => combo_choice_answer.to_param, :combo_choice_answer => valid_attributes}, valid_session
          response.should redirect_to(combo_choice_answer)
        end
      end

      describe "with invalid params" do
        it "assigns the combo_choice_answer as @combo_choice_answer" do
          combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoiceAnswer.any_instance.stub(:save).and_return(false)
          put :update, {:id => combo_choice_answer.to_param, :combo_choice_answer => { "number" => "invalid value" }}, valid_session
          assigns(:combo_choice_answer).should eq(combo_choice_answer)
        end

        it "re-renders the 'edit' template" do
          combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoiceAnswer.any_instance.stub(:save).and_return(false)
          put :update, {:id => combo_choice_answer.to_param, :combo_choice_answer => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested combo_choice_answer" do
        combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
        expect {
          delete :destroy, {:id => combo_choice_answer.to_param}, valid_session
        }.to change(ComboChoiceAnswer, :count).by(-1)
      end

      it "redirects to the combo_choice_answers list" do
        combo_choice_answer = ComboChoiceAnswer.create! valid_attributes
        delete :destroy, {:id => combo_choice_answer.to_param}, valid_session
        response.should redirect_to(combo_choice_answers_url)
      end
    end

  end
end
