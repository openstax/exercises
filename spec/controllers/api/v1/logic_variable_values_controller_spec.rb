require "rails_helper"

module Api::V1
  RSpec.describe LogicVariableValuesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LogicVariableValue. As you add validations to LogicVariableValue, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicVariableValuesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logic_variable_values as @logic_variable_values" do
        logic_variable_value = LogicVariableValue.create! valid_attributes
        get :index, {}, valid_session
        assigns(:logic_variable_values).should eq([logic_variable_value])
      end
    end

    describe "GET show" do
      it "assigns the requested logic_variable_value as @logic_variable_value" do
        logic_variable_value = LogicVariableValue.create! valid_attributes
        get :show, {:id => logic_variable_value.to_param}, valid_session
        assigns(:logic_variable_value).should eq(logic_variable_value)
      end
    end

    describe "GET new" do
      it "assigns a new logic_variable_value as @logic_variable_value" do
        get :new, {}, valid_session
        assigns(:logic_variable_value).should be_a_new(LogicVariableValue)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic_variable_value as @logic_variable_value" do
        logic_variable_value = LogicVariableValue.create! valid_attributes
        get :edit, {:id => logic_variable_value.to_param}, valid_session
        assigns(:logic_variable_value).should eq(logic_variable_value)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LogicVariableValue" do
          expect {
            post :create, {:logic_variable_value => valid_attributes}, valid_session
          }.to change(LogicVariableValue, :count).by(1)
        end

        it "assigns a newly created logic_variable_value as @logic_variable_value" do
          post :create, {:logic_variable_value => valid_attributes}, valid_session
          assigns(:logic_variable_value).should be_a(LogicVariableValue)
          assigns(:logic_variable_value).should be_persisted
        end

        it "redirects to the created logic_variable_value" do
          post :create, {:logic_variable_value => valid_attributes}, valid_session
          response.should redirect_to(LogicVariableValue.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic_variable_value as @logic_variable_value" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicVariableValue.any_instance.stub(:save).and_return(false)
          post :create, {:logic_variable_value => { "number" => "invalid value" }}, valid_session
          assigns(:logic_variable_value).should be_a_new(LogicVariableValue)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicVariableValue.any_instance.stub(:save).and_return(false)
          post :create, {:logic_variable_value => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested logic_variable_value" do
          logic_variable_value = LogicVariableValue.create! valid_attributes
          # Assuming there are no other logic_variable_values in the database, this
          # specifies that the LogicVariableValue created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LogicVariableValue.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => logic_variable_value.to_param, :logic_variable_value => { "number" => "1" }}, valid_session
        end

        it "assigns the requested logic_variable_value as @logic_variable_value" do
          logic_variable_value = LogicVariableValue.create! valid_attributes
          put :update, {:id => logic_variable_value.to_param, :logic_variable_value => valid_attributes}, valid_session
          assigns(:logic_variable_value).should eq(logic_variable_value)
        end

        it "redirects to the logic_variable_value" do
          logic_variable_value = LogicVariableValue.create! valid_attributes
          put :update, {:id => logic_variable_value.to_param, :logic_variable_value => valid_attributes}, valid_session
          response.should redirect_to(logic_variable_value)
        end
      end

      describe "with invalid params" do
        it "assigns the logic_variable_value as @logic_variable_value" do
          logic_variable_value = LogicVariableValue.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicVariableValue.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_variable_value.to_param, :logic_variable_value => { "number" => "invalid value" }}, valid_session
          assigns(:logic_variable_value).should eq(logic_variable_value)
        end

        it "re-renders the 'edit' template" do
          logic_variable_value = LogicVariableValue.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicVariableValue.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_variable_value.to_param, :logic_variable_value => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic_variable_value" do
        logic_variable_value = LogicVariableValue.create! valid_attributes
        expect {
          delete :destroy, {:id => logic_variable_value.to_param}, valid_session
        }.to change(LogicVariableValue, :count).by(-1)
      end

      it "redirects to the logic_variable_values list" do
        logic_variable_value = LogicVariableValue.create! valid_attributes
        delete :destroy, {:id => logic_variable_value.to_param}, valid_session
        response.should redirect_to(logic_variable_values_url)
      end
    end

  end
end
