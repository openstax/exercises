require 'spec_helper'

module Api::V1
  describe ComboChoicesController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # ComboChoice. As you add validations to ComboChoice, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ComboChoicesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all combo_choices as @combo_choices" do
        combo_choice = ComboChoice.create! valid_attributes
        get :index, {}, valid_session
        assigns(:combo_choices).should eq([combo_choice])
      end
    end

    describe "GET show" do
      it "assigns the requested combo_choice as @combo_choice" do
        combo_choice = ComboChoice.create! valid_attributes
        get :show, {:id => combo_choice.to_param}, valid_session
        assigns(:combo_choice).should eq(combo_choice)
      end
    end

    describe "GET new" do
      it "assigns a new combo_choice as @combo_choice" do
        get :new, {}, valid_session
        assigns(:combo_choice).should be_a_new(ComboChoice)
      end
    end

    describe "GET edit" do
      it "assigns the requested combo_choice as @combo_choice" do
        combo_choice = ComboChoice.create! valid_attributes
        get :edit, {:id => combo_choice.to_param}, valid_session
        assigns(:combo_choice).should eq(combo_choice)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ComboChoice" do
          expect {
            post :create, {:combo_choice => valid_attributes}, valid_session
          }.to change(ComboChoice, :count).by(1)
        end

        it "assigns a newly created combo_choice as @combo_choice" do
          post :create, {:combo_choice => valid_attributes}, valid_session
          assigns(:combo_choice).should be_a(ComboChoice)
          assigns(:combo_choice).should be_persisted
        end

        it "redirects to the created combo_choice" do
          post :create, {:combo_choice => valid_attributes}, valid_session
          response.should redirect_to(ComboChoice.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved combo_choice as @combo_choice" do
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoice.any_instance.stub(:save).and_return(false)
          post :create, {:combo_choice => { "number" => "invalid value" }}, valid_session
          assigns(:combo_choice).should be_a_new(ComboChoice)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoice.any_instance.stub(:save).and_return(false)
          post :create, {:combo_choice => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested combo_choice" do
          combo_choice = ComboChoice.create! valid_attributes
          # Assuming there are no other combo_choices in the database, this
          # specifies that the ComboChoice created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ComboChoice.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => combo_choice.to_param, :combo_choice => { "number" => "1" }}, valid_session
        end

        it "assigns the requested combo_choice as @combo_choice" do
          combo_choice = ComboChoice.create! valid_attributes
          put :update, {:id => combo_choice.to_param, :combo_choice => valid_attributes}, valid_session
          assigns(:combo_choice).should eq(combo_choice)
        end

        it "redirects to the combo_choice" do
          combo_choice = ComboChoice.create! valid_attributes
          put :update, {:id => combo_choice.to_param, :combo_choice => valid_attributes}, valid_session
          response.should redirect_to(combo_choice)
        end
      end

      describe "with invalid params" do
        it "assigns the combo_choice as @combo_choice" do
          combo_choice = ComboChoice.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoice.any_instance.stub(:save).and_return(false)
          put :update, {:id => combo_choice.to_param, :combo_choice => { "number" => "invalid value" }}, valid_session
          assigns(:combo_choice).should eq(combo_choice)
        end

        it "re-renders the 'edit' template" do
          combo_choice = ComboChoice.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ComboChoice.any_instance.stub(:save).and_return(false)
          put :update, {:id => combo_choice.to_param, :combo_choice => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested combo_choice" do
        combo_choice = ComboChoice.create! valid_attributes
        expect {
          delete :destroy, {:id => combo_choice.to_param}, valid_session
        }.to change(ComboChoice, :count).by(-1)
      end

      it "redirects to the combo_choices list" do
        combo_choice = ComboChoice.create! valid_attributes
        delete :destroy, {:id => combo_choice.to_param}, valid_session
        response.should redirect_to(combo_choices_url)
      end
    end

  end
end
