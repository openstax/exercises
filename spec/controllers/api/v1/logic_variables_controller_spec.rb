require 'rails_helper'

module Api::V1
  RSpec.describe LogicVariablesController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # LogicVariable. As you add validations to LogicVariable, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicVariablesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logic_variables as @logic_variables" do
        logic_variable = LogicVariable.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:logic_variables)).to eq([logic_variable])
      end
    end

    describe "GET show" do
      it "assigns the requested logic_variable as @logic_variable" do
        logic_variable = LogicVariable.create! valid_attributes
        get :show, {:id => logic_variable.to_param}, valid_session
        expect(assigns(:logic_variable)).to eq(logic_variable)
      end
    end

    describe "GET new" do
      it "assigns a new logic_variable as @logic_variable" do
        get :new, {}, valid_session
        expect(assigns(:logic_variable)).to be_a_new(LogicVariable)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic_variable as @logic_variable" do
        logic_variable = LogicVariable.create! valid_attributes
        get :edit, {:id => logic_variable.to_param}, valid_session
        expect(assigns(:logic_variable)).to eq(logic_variable)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LogicVariable" do
          expect {
            post :create, {:logic_variable => valid_attributes}, valid_session
          }.to change(LogicVariable, :count).by(1)
        end

        it "assigns a newly created logic_variable as @logic_variable" do
          post :create, {:logic_variable => valid_attributes}, valid_session
          expect(assigns(:logic_variable)).to be_a(LogicVariable)
          expect(assigns(:logic_variable)).to be_persisted
        end

        it "redirects to the created logic_variable" do
          post :create, {:logic_variable => valid_attributes}, valid_session
          expect(response).to redirect_to(LogicVariable.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic_variable as @logic_variable" do
          post :create, {:logic_variable => invalid_attributes}, valid_session
          expect(assigns(:logic_variable)).to be_a_new(LogicVariable)
        end

        it "re-renders the 'new' template" do
          post :create, {:logic_variable => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested logic_variable" do
          logic_variable = LogicVariable.create! valid_attributes
          put :update, {:id => logic_variable.to_param, :logic_variable => new_attributes}, valid_session
          logic_variable.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested logic_variable as @logic_variable" do
          logic_variable = LogicVariable.create! valid_attributes
          put :update, {:id => logic_variable.to_param, :logic_variable => valid_attributes}, valid_session
          expect(assigns(:logic_variable)).to eq(logic_variable)
        end

        it "redirects to the logic_variable" do
          logic_variable = LogicVariable.create! valid_attributes
          put :update, {:id => logic_variable.to_param, :logic_variable => valid_attributes}, valid_session
          expect(response).to redirect_to(logic_variable)
        end
      end

      describe "with invalid params" do
        it "assigns the logic_variable as @logic_variable" do
          logic_variable = LogicVariable.create! valid_attributes
          put :update, {:id => logic_variable.to_param, :logic_variable => invalid_attributes}, valid_session
          expect(assigns(:logic_variable)).to eq(logic_variable)
        end

        it "re-renders the 'edit' template" do
          logic_variable = LogicVariable.create! valid_attributes
          put :update, {:id => logic_variable.to_param, :logic_variable => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic_variable" do
        logic_variable = LogicVariable.create! valid_attributes
        expect {
          delete :destroy, {:id => logic_variable.to_param}, valid_session
        }.to change(LogicVariable, :count).by(-1)
      end

      it "redirects to the logic_variables list" do
        logic_variable = LogicVariable.create! valid_attributes
        delete :destroy, {:id => logic_variable.to_param}, valid_session
        expect(response).to redirect_to(logic_variables_url)
      end
    end

  end
end
