require "rails_helper"

module Api::V1
  RSpec.describe LogicOutputsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # LogicOutput. As you add validations to LogicOutput, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicOutputsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logic_outputs as @logic_outputs" do
        logic_output = LogicOutput.create! valid_attributes
        get :index, {}, valid_session
        assigns(:logic_outputs).should eq([logic_output])
      end
    end

    describe "GET show" do
      it "assigns the requested logic_output as @logic_output" do
        logic_output = LogicOutput.create! valid_attributes
        get :show, {:id => logic_output.to_param}, valid_session
        assigns(:logic_output).should eq(logic_output)
      end
    end

    describe "GET new" do
      it "assigns a new logic_output as @logic_output" do
        get :new, {}, valid_session
        assigns(:logic_output).should be_a_new(LogicOutput)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic_output as @logic_output" do
        logic_output = LogicOutput.create! valid_attributes
        get :edit, {:id => logic_output.to_param}, valid_session
        assigns(:logic_output).should eq(logic_output)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new LogicOutput" do
          expect {
            post :create, {:logic_output => valid_attributes}, valid_session
          }.to change(LogicOutput, :count).by(1)
        end

        it "assigns a newly created logic_output as @logic_output" do
          post :create, {:logic_output => valid_attributes}, valid_session
          assigns(:logic_output).should be_a(LogicOutput)
          assigns(:logic_output).should be_persisted
        end

        it "redirects to the created logic_output" do
          post :create, {:logic_output => valid_attributes}, valid_session
          response.should redirect_to(LogicOutput.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic_output as @logic_output" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicOutput.any_instance.stub(:save).and_return(false)
          post :create, {:logic_output => { "number" => "invalid value" }}, valid_session
          assigns(:logic_output).should be_a_new(LogicOutput)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          LogicOutput.any_instance.stub(:save).and_return(false)
          post :create, {:logic_output => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested logic_output" do
          logic_output = LogicOutput.create! valid_attributes
          # Assuming there are no other logic_outputs in the database, this
          # specifies that the LogicOutput created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          LogicOutput.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => logic_output.to_param, :logic_output => { "number" => "1" }}, valid_session
        end

        it "assigns the requested logic_output as @logic_output" do
          logic_output = LogicOutput.create! valid_attributes
          put :update, {:id => logic_output.to_param, :logic_output => valid_attributes}, valid_session
          assigns(:logic_output).should eq(logic_output)
        end

        it "redirects to the logic_output" do
          logic_output = LogicOutput.create! valid_attributes
          put :update, {:id => logic_output.to_param, :logic_output => valid_attributes}, valid_session
          response.should redirect_to(logic_output)
        end
      end

      describe "with invalid params" do
        it "assigns the logic_output as @logic_output" do
          logic_output = LogicOutput.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicOutput.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_output.to_param, :logic_output => { "number" => "invalid value" }}, valid_session
          assigns(:logic_output).should eq(logic_output)
        end

        it "re-renders the 'edit' template" do
          logic_output = LogicOutput.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          LogicOutput.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic_output.to_param, :logic_output => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic_output" do
        logic_output = LogicOutput.create! valid_attributes
        expect {
          delete :destroy, {:id => logic_output.to_param}, valid_session
        }.to change(LogicOutput, :count).by(-1)
      end

      it "redirects to the logic_outputs list" do
        logic_output = LogicOutput.create! valid_attributes
        delete :destroy, {:id => logic_output.to_param}, valid_session
        response.should redirect_to(logic_outputs_url)
      end
    end

  end
end
