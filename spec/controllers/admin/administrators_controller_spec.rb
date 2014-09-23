require "rails_helper"

module Admin
  RSpec.describe AdministratorsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Administrator. As you add validations to Administrator, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # AdministratorsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all administrators as @administrators" do
        administrator = Administrator.create! valid_attributes
        get :index, {}, valid_session
        assigns(:administrators).should eq([administrator])
      end
    end

    describe "GET show" do
      it "assigns the requested administrator as @administrator" do
        administrator = Administrator.create! valid_attributes
        get :show, {:id => administrator.to_param}, valid_session
        assigns(:administrator).should eq(administrator)
      end
    end

    describe "GET new" do
      it "assigns a new administrator as @administrator" do
        get :new, {}, valid_session
        assigns(:administrator).should be_a_new(Administrator)
      end
    end

    describe "GET edit" do
      it "assigns the requested administrator as @administrator" do
        administrator = Administrator.create! valid_attributes
        get :edit, {:id => administrator.to_param}, valid_session
        assigns(:administrator).should eq(administrator)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Administrator" do
          expect {
            post :create, {:administrator => valid_attributes}, valid_session
          }.to change(Administrator, :count).by(1)
        end

        it "assigns a newly created administrator as @administrator" do
          post :create, {:administrator => valid_attributes}, valid_session
          assigns(:administrator).should be_a(Administrator)
          assigns(:administrator).should be_persisted
        end

        it "redirects to the created administrator" do
          post :create, {:administrator => valid_attributes}, valid_session
          response.should redirect_to(Administrator.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved administrator as @administrator" do
          # Trigger the behavior that occurs when invalid params are submitted
          Administrator.any_instance.stub(:save).and_return(false)
          post :create, {:administrator => { "number" => "invalid value" }}, valid_session
          assigns(:administrator).should be_a_new(Administrator)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Administrator.any_instance.stub(:save).and_return(false)
          post :create, {:administrator => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested administrator" do
          administrator = Administrator.create! valid_attributes
          # Assuming there are no other administrators in the database, this
          # specifies that the Administrator created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Administrator.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => administrator.to_param, :administrator => { "number" => "1" }}, valid_session
        end

        it "assigns the requested administrator as @administrator" do
          administrator = Administrator.create! valid_attributes
          put :update, {:id => administrator.to_param, :administrator => valid_attributes}, valid_session
          assigns(:administrator).should eq(administrator)
        end

        it "redirects to the administrator" do
          administrator = Administrator.create! valid_attributes
          put :update, {:id => administrator.to_param, :administrator => valid_attributes}, valid_session
          response.should redirect_to(administrator)
        end
      end

      describe "with invalid params" do
        it "assigns the administrator as @administrator" do
          administrator = Administrator.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Administrator.any_instance.stub(:save).and_return(false)
          put :update, {:id => administrator.to_param, :administrator => { "number" => "invalid value" }}, valid_session
          assigns(:administrator).should eq(administrator)
        end

        it "re-renders the 'edit' template" do
          administrator = Administrator.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Administrator.any_instance.stub(:save).and_return(false)
          put :update, {:id => administrator.to_param, :administrator => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested administrator" do
        administrator = Administrator.create! valid_attributes
        expect {
          delete :destroy, {:id => administrator.to_param}, valid_session
        }.to change(Administrator, :count).by(-1)
      end

      it "redirects to the administrators list" do
        administrator = Administrator.create! valid_attributes
        delete :destroy, {:id => administrator.to_param}, valid_session
        response.should redirect_to(administrators_url)
      end
    end

  end
end
