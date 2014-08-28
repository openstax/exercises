require "rails_helper"

module Api::V1
  RSpec.describe FormattingsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Formatting. As you add validations to Formatting, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # FormattingsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all formattings as @formattings" do
        formatting = Formatting.create! valid_attributes
        get :index, {}, valid_session
        assigns(:formattings).should eq([formatting])
      end
    end

    describe "GET show" do
      it "assigns the requested formatting as @formatting" do
        formatting = Formatting.create! valid_attributes
        get :show, {:id => formatting.to_param}, valid_session
        assigns(:formatting).should eq(formatting)
      end
    end

    describe "GET new" do
      it "assigns a new formatting as @formatting" do
        get :new, {}, valid_session
        assigns(:formatting).should be_a_new(Formatting)
      end
    end

    describe "GET edit" do
      it "assigns the requested formatting as @formatting" do
        formatting = Formatting.create! valid_attributes
        get :edit, {:id => formatting.to_param}, valid_session
        assigns(:formatting).should eq(formatting)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Formatting" do
          expect {
            post :create, {:formatting => valid_attributes}, valid_session
          }.to change(Formatting, :count).by(1)
        end

        it "assigns a newly created formatting as @formatting" do
          post :create, {:formatting => valid_attributes}, valid_session
          assigns(:formatting).should be_a(Formatting)
          assigns(:formatting).should be_persisted
        end

        it "redirects to the created formatting" do
          post :create, {:formatting => valid_attributes}, valid_session
          response.should redirect_to(Formatting.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved formatting as @formatting" do
          # Trigger the behavior that occurs when invalid params are submitted
          Formatting.any_instance.stub(:save).and_return(false)
          post :create, {:formatting => { "number" => "invalid value" }}, valid_session
          assigns(:formatting).should be_a_new(Formatting)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Formatting.any_instance.stub(:save).and_return(false)
          post :create, {:formatting => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested formatting" do
          formatting = Formatting.create! valid_attributes
          # Assuming there are no other formattings in the database, this
          # specifies that the Formatting created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Formatting.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => formatting.to_param, :formatting => { "number" => "1" }}, valid_session
        end

        it "assigns the requested formatting as @formatting" do
          formatting = Formatting.create! valid_attributes
          put :update, {:id => formatting.to_param, :formatting => valid_attributes}, valid_session
          assigns(:formatting).should eq(formatting)
        end

        it "redirects to the formatting" do
          formatting = Formatting.create! valid_attributes
          put :update, {:id => formatting.to_param, :formatting => valid_attributes}, valid_session
          response.should redirect_to(formatting)
        end
      end

      describe "with invalid params" do
        it "assigns the formatting as @formatting" do
          formatting = Formatting.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Formatting.any_instance.stub(:save).and_return(false)
          put :update, {:id => formatting.to_param, :formatting => { "number" => "invalid value" }}, valid_session
          assigns(:formatting).should eq(formatting)
        end

        it "re-renders the 'edit' template" do
          formatting = Formatting.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Formatting.any_instance.stub(:save).and_return(false)
          put :update, {:id => formatting.to_param, :formatting => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested formatting" do
        formatting = Formatting.create! valid_attributes
        expect {
          delete :destroy, {:id => formatting.to_param}, valid_session
        }.to change(Formatting, :count).by(-1)
      end

      it "redirects to the formattings list" do
        formatting = Formatting.create! valid_attributes
        delete :destroy, {:id => formatting.to_param}, valid_session
        response.should redirect_to(formattings_url)
      end
    end

  end
end
