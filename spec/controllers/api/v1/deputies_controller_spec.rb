require 'spec_helper'

module Api::V1
  describe DeputiesController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # Deputy. As you add validations to Deputy, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # DeputiesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all deputies as @deputies" do
        deputy = Deputy.create! valid_attributes
        get :index, {}, valid_session
        assigns(:deputies).should eq([deputy])
      end
    end

    describe "GET show" do
      it "assigns the requested deputy as @deputy" do
        deputy = Deputy.create! valid_attributes
        get :show, {:id => deputy.to_param}, valid_session
        assigns(:deputy).should eq(deputy)
      end
    end

    describe "GET new" do
      it "assigns a new deputy as @deputy" do
        get :new, {}, valid_session
        assigns(:deputy).should be_a_new(Deputy)
      end
    end

    describe "GET edit" do
      it "assigns the requested deputy as @deputy" do
        deputy = Deputy.create! valid_attributes
        get :edit, {:id => deputy.to_param}, valid_session
        assigns(:deputy).should eq(deputy)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Deputy" do
          expect {
            post :create, {:deputy => valid_attributes}, valid_session
          }.to change(Deputy, :count).by(1)
        end

        it "assigns a newly created deputy as @deputy" do
          post :create, {:deputy => valid_attributes}, valid_session
          assigns(:deputy).should be_a(Deputy)
          assigns(:deputy).should be_persisted
        end

        it "redirects to the created deputy" do
          post :create, {:deputy => valid_attributes}, valid_session
          response.should redirect_to(Deputy.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved deputy as @deputy" do
          # Trigger the behavior that occurs when invalid params are submitted
          Deputy.any_instance.stub(:save).and_return(false)
          post :create, {:deputy => { "number" => "invalid value" }}, valid_session
          assigns(:deputy).should be_a_new(Deputy)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Deputy.any_instance.stub(:save).and_return(false)
          post :create, {:deputy => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested deputy" do
          deputy = Deputy.create! valid_attributes
          # Assuming there are no other deputies in the database, this
          # specifies that the Deputy created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Deputy.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => deputy.to_param, :deputy => { "number" => "1" }}, valid_session
        end

        it "assigns the requested deputy as @deputy" do
          deputy = Deputy.create! valid_attributes
          put :update, {:id => deputy.to_param, :deputy => valid_attributes}, valid_session
          assigns(:deputy).should eq(deputy)
        end

        it "redirects to the deputy" do
          deputy = Deputy.create! valid_attributes
          put :update, {:id => deputy.to_param, :deputy => valid_attributes}, valid_session
          response.should redirect_to(deputy)
        end
      end

      describe "with invalid params" do
        it "assigns the deputy as @deputy" do
          deputy = Deputy.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Deputy.any_instance.stub(:save).and_return(false)
          put :update, {:id => deputy.to_param, :deputy => { "number" => "invalid value" }}, valid_session
          assigns(:deputy).should eq(deputy)
        end

        it "re-renders the 'edit' template" do
          deputy = Deputy.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Deputy.any_instance.stub(:save).and_return(false)
          put :update, {:id => deputy.to_param, :deputy => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested deputy" do
        deputy = Deputy.create! valid_attributes
        expect {
          delete :destroy, {:id => deputy.to_param}, valid_session
        }.to change(Deputy, :count).by(-1)
      end

      it "redirects to the deputies list" do
        deputy = Deputy.create! valid_attributes
        delete :destroy, {:id => deputy.to_param}, valid_session
        response.should redirect_to(deputies_url)
      end
    end

  end
end
