require 'rails_helper'

module Api::V1
  RSpec.describe CommunitySolutionsController, type: :controller, api: true, version: :v1 do

    before do
      # To be implemented
      skip
    end

    context "GET index" do
      it "assigns all solutions as @solutions" do
        solution = CommunitySolution.create! valid_attributes
        get :index, session: valid_session
        expect(assigns(:solutions)).to eq([solution])
      end
    end

    context "GET show" do
      it "assigns the requested solution as @solution" do
        solution = CommunitySolution.create! valid_attributes
        get :show, params: { id: solution.to_param }, session: valid_session
        expect(assigns(:solution)).to eq(solution)
      end
    end

    context "POST create" do
      context "with valid params" do
        it "creates a new CommunitySolution" do
          expect {
            post :create, params: { solution: valid_attributes }, session: valid_session
          }.to change(CommunitySolution, :count).by(1)
        end

        it "assigns a newly created solution as @solution" do
          post :create, params: { solution: valid_attributes }, session: valid_session
          expect(assigns(:solution)).to be_a(CommunitySolution)
          expect(assigns(:solution)).to be_persisted
        end

        it "redirects to the created solution" do
          post :create, params: { solution: valid_attributes }, session: valid_session
          expect(response).to redirect_to(CommunitySolution.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved solution as @solution" do
          # Trigger the behavior that occurs when invalid params are submitted
          CommunitySolution.any_instance.stub(:save).and_return(false)
          post :create, params: { solution: { "number" => "invalid value" } }, session: valid_session
          expect(assigns(:solution)).to be_a_new(CommunitySolution)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CommunitySolution.any_instance.stub(:save).and_return(false)
          post :create, params: { solution: { "number" => "invalid value" } }, session: valid_session
          expect(response).to render_template("new")
        end
      end
    end

    context "PUT update" do
      context "with valid params" do
        it "updates the requested solution" do
          solution = CommunitySolution.create! valid_attributes
          # Assuming there are no other solutions in the database, this
          # specifies that the CommunitySolution created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect(CommunitySolution.any_instance).to_receive(:update_attributes).with({ "number" => "1" })
          put :update, params: { id: solution.to_param, solution: { "number" => "1" } }, session: valid_session
        end

        it "assigns the requested solution as @solution" do
          solution = CommunitySolution.create! valid_attributes
          put :update, params: { id: solution.to_param, solution: valid_attributes }, session: valid_session
          expect(assigns(:solution)).to eq(solution)
        end

        it "redirects to the solution" do
          solution = CommunitySolution.create! valid_attributes
          put :update, params: { id: solution.to_param, solution: valid_attributes }, session: valid_session
          expect(response).to redirect_to(solution)
        end
      end

      context "with invalid params" do
        it "assigns the solution as @solution" do
          solution = CommunitySolution.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CommunitySolution.any_instance.stub(:save).and_return(false)
          put :update, params: { id: solution.to_param, solution: { "number" => "invalid value" } }, session: valid_session
          expect(assigns(:solution)).to eq(solution)
        end

        it "re-renders the 'edit' template" do
          solution = CommunitySolution.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CommunitySolution.any_instance.stub(:save).and_return(false)
          put :update, params: { id: solution.to_param, solution: { "number" => "invalid value" } }, session: valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    context "DELETE destroy" do
      it "destroys the requested solution" do
        solution = CommunitySolution.create! valid_attributes
        expect {
          delete :destroy, params: { id: solution.to_param }, session: valid_session
        }.to change(CommunitySolution, :count).by(-1)
      end

      it "redirects to the solutions list" do
        solution = CommunitySolution.create! valid_attributes
        delete :destroy, params: { id: solution.to_param }, session: valid_session
        expect(response).to redirect_to(solutions_url)
      end
    end

  end
end
