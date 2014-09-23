require "rails_helper"

RSpec.describe DeputizationsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Deputization. As you add validations to Deputization, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "number" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DeputizationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all deputizations as @deputizations" do
      deputization = Deputization.create! valid_attributes
      get :index, {}, valid_session
      assigns(:deputizations).should eq([deputization])
    end
  end

  describe "GET show" do
    it "assigns the requested deputization as @deputization" do
      deputization = Deputization.create! valid_attributes
      get :show, {:id => deputization.to_param}, valid_session
      assigns(:deputization).should eq(deputization)
    end
  end

  describe "GET new" do
    it "assigns a new deputization as @deputization" do
      get :new, {}, valid_session
      assigns(:deputization).should be_a_new(Deputization)
    end
  end

  describe "GET edit" do
    it "assigns the requested deputization as @deputization" do
      deputization = Deputization.create! valid_attributes
      get :edit, {:id => deputization.to_param}, valid_session
      assigns(:deputization).should eq(deputization)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Deputization" do
        expect {
          post :create, {:deputization => valid_attributes}, valid_session
        }.to change(Deputization, :count).by(1)
      end

      it "assigns a newly created deputization as @deputization" do
        post :create, {:deputization => valid_attributes}, valid_session
        assigns(:deputization).should be_a(Deputization)
        assigns(:deputization).should be_persisted
      end

      it "redirects to the created deputization" do
        post :create, {:deputization => valid_attributes}, valid_session
        response.should redirect_to(Deputization.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved deputization as @deputization" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deputization.any_instance.stub(:save).and_return(false)
        post :create, {:deputization => { "number" => "invalid value" }}, valid_session
        assigns(:deputization).should be_a_new(Deputization)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deputization.any_instance.stub(:save).and_return(false)
        post :create, {:deputization => { "number" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested deputization" do
        deputization = Deputization.create! valid_attributes
        # Assuming there are no other deputizations in the database, this
        # specifies that the Deputization created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Deputization.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
        put :update, {:id => deputization.to_param, :deputization => { "number" => "1" }}, valid_session
      end

      it "assigns the requested deputization as @deputization" do
        deputization = Deputization.create! valid_attributes
        put :update, {:id => deputization.to_param, :deputization => valid_attributes}, valid_session
        assigns(:deputization).should eq(deputization)
      end

      it "redirects to the deputization" do
        deputization = Deputization.create! valid_attributes
        put :update, {:id => deputization.to_param, :deputization => valid_attributes}, valid_session
        response.should redirect_to(deputization)
      end
    end

    describe "with invalid params" do
      it "assigns the deputization as @deputization" do
        deputization = Deputization.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deputization.any_instance.stub(:save).and_return(false)
        put :update, {:id => deputization.to_param, :deputization => { "number" => "invalid value" }}, valid_session
        assigns(:deputization).should eq(deputization)
      end

      it "re-renders the 'edit' template" do
        deputization = Deputization.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deputization.any_instance.stub(:save).and_return(false)
        put :update, {:id => deputization.to_param, :deputization => { "number" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested deputization" do
      deputization = Deputization.create! valid_attributes
      expect {
        delete :destroy, {:id => deputization.to_param}, valid_session
      }.to change(Deputization, :count).by(-1)
    end

    it "redirects to the deputizations list" do
      deputization = Deputization.create! valid_attributes
      delete :destroy, {:id => deputization.to_param}, valid_session
      response.should redirect_to(deputizations_url)
    end
  end

end
