require 'rails_helper'

module Api::V1
  describe PartsController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Part. As you add validations to Part, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PartsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all parts as @parts" do
        part = Part.create! valid_attributes
        get :index, {}, valid_session
        assigns(:parts).should eq([part])
      end
    end

    describe "GET show" do
      it "assigns the requested part as @part" do
        part = Part.create! valid_attributes
        get :show, {:id => part.to_param}, valid_session
        assigns(:part).should eq(part)
      end
    end

    describe "GET new" do
      it "assigns a new part as @part" do
        get :new, {}, valid_session
        assigns(:part).should be_a_new(Part)
      end
    end

    describe "GET edit" do
      it "assigns the requested part as @part" do
        part = Part.create! valid_attributes
        get :edit, {:id => part.to_param}, valid_session
        assigns(:part).should eq(part)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Part" do
          expect {
            post :create, {:part => valid_attributes}, valid_session
          }.to change(Part, :count).by(1)
        end

        it "assigns a newly created part as @part" do
          post :create, {:part => valid_attributes}, valid_session
          assigns(:part).should be_a(Part)
          assigns(:part).should be_persisted
        end

        it "redirects to the created part" do
          post :create, {:part => valid_attributes}, valid_session
          response.should redirect_to(Part.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved part as @part" do
          # Trigger the behavior that occurs when invalid params are submitted
          Part.any_instance.stub(:save).and_return(false)
          post :create, {:part => { "number" => "invalid value" }}, valid_session
          assigns(:part).should be_a_new(Part)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Part.any_instance.stub(:save).and_return(false)
          post :create, {:part => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested part" do
          part = Part.create! valid_attributes
          # Assuming there are no other parts in the database, this
          # specifies that the Part created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Part.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => part.to_param, :part => { "number" => "1" }}, valid_session
        end

        it "assigns the requested part as @part" do
          part = Part.create! valid_attributes
          put :update, {:id => part.to_param, :part => valid_attributes}, valid_session
          assigns(:part).should eq(part)
        end

        it "redirects to the part" do
          part = Part.create! valid_attributes
          put :update, {:id => part.to_param, :part => valid_attributes}, valid_session
          response.should redirect_to(part)
        end
      end

      describe "with invalid params" do
        it "assigns the part as @part" do
          part = Part.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Part.any_instance.stub(:save).and_return(false)
          put :update, {:id => part.to_param, :part => { "number" => "invalid value" }}, valid_session
          assigns(:part).should eq(part)
        end

        it "re-renders the 'edit' template" do
          part = Part.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Part.any_instance.stub(:save).and_return(false)
          put :update, {:id => part.to_param, :part => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested part" do
        part = Part.create! valid_attributes
        expect {
          delete :destroy, {:id => part.to_param}, valid_session
        }.to change(Part, :count).by(-1)
      end

      it "redirects to the parts list" do
        part = Part.create! valid_attributes
        delete :destroy, {:id => part.to_param}, valid_session
        response.should redirect_to(parts_url)
      end
    end

  end
end
