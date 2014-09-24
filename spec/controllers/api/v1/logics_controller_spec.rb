require "rails_helper"

module Api::V1
  RSpec.describe LogicsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Logic. As you add validations to Logic, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LogicsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all logics as @logics" do
        logic = Logic.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:logics)).to eq([logic])
      end
    end

    describe "GET show" do
      it "assigns the requested logic as @logic" do
        logic = Logic.create! valid_attributes
        get :show, {:id => logic.to_param}, valid_session
        expect(assigns(:logic)).to eq(logic)
      end
    end

    describe "GET new" do
      it "assigns a new logic as @logic" do
        get :new, {}, valid_session
        expect(assigns(:logic)).to be_a_new(Logic)
      end
    end

    describe "GET edit" do
      it "assigns the requested logic as @logic" do
        logic = Logic.create! valid_attributes
        get :edit, {:id => logic.to_param}, valid_session
        expect(assigns(:logic)).to eq(logic)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Logic" do
          expect {
            post :create, {:logic => valid_attributes}, valid_session
          }.to change(Logic, :count).by(1)
        end

        it "assigns a newly created logic as @logic" do
          post :create, {:logic => valid_attributes}, valid_session
          expect(assigns(:logic)).to be_a(Logic)
          expect(assigns(:logic)).to be_persisted
        end

        it "redirects to the created logic" do
          post :create, {:logic => valid_attributes}, valid_session
          expect(response).to redirect_to(Logic.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved logic as @logic" do
          # Trigger the behavior that occurs when invalid params are submitted
          Logic.any_instance.stub(:save).and_return(false)
          post :create, {:logic => { "number" => "invalid value" }}, valid_session
          expect(assigns(:logic)).to be_a_new(Logic)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Logic.any_instance.stub(:save).and_return(false)
          post :create, {:logic => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested logic" do
          logic = Logic.create! valid_attributes
          # Assuming there are no other logics in the database, this
          # specifies that the Logic created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect(Logic.any_instance).to_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => logic.to_param, :logic => { "number" => "1" }}, valid_session
        end

        it "assigns the requested logic as @logic" do
          logic = Logic.create! valid_attributes
          put :update, {:id => logic.to_param, :logic => valid_attributes}, valid_session
          expect(assigns(:logic)).to eq(logic)
        end

        it "redirects to the logic" do
          logic = Logic.create! valid_attributes
          put :update, {:id => logic.to_param, :logic => valid_attributes}, valid_session
          expect(response).to redirect_to(logic)
        end
      end

      describe "with invalid params" do
        it "assigns the logic as @logic" do
          logic = Logic.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Logic.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic.to_param, :logic => { "number" => "invalid value" }}, valid_session
          expect(assigns(:logic)).to eq(logic)
        end

        it "re-renders the 'edit' template" do
          logic = Logic.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Logic.any_instance.stub(:save).and_return(false)
          put :update, {:id => logic.to_param, :logic => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested logic" do
        logic = Logic.create! valid_attributes
        expect {
          delete :destroy, {:id => logic.to_param}, valid_session
        }.to change(Logic, :count).by(-1)
      end

      it "redirects to the logics list" do
        logic = Logic.create! valid_attributes
        delete :destroy, {:id => logic.to_param}, valid_session
        expect(response).to redirect_to(logics_url)
      end
    end

  end
end
