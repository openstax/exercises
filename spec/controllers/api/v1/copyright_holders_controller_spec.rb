require 'spec_helper'

module Api::V1
  describe CopyrightHoldersController, type: :api, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # CopyrightHolder. As you add validations to CopyrightHolder, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # CopyrightHoldersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all copyright_holders as @copyright_holders" do
        copyright_holder = CopyrightHolder.create! valid_attributes
        get :index, {}, valid_session
        assigns(:copyright_holders).should eq([copyright_holder])
      end
    end

    describe "GET show" do
      it "assigns the requested copyright_holder as @copyright_holder" do
        copyright_holder = CopyrightHolder.create! valid_attributes
        get :show, {:id => copyright_holder.to_param}, valid_session
        assigns(:copyright_holder).should eq(copyright_holder)
      end
    end

    describe "GET new" do
      it "assigns a new copyright_holder as @copyright_holder" do
        get :new, {}, valid_session
        assigns(:copyright_holder).should be_a_new(CopyrightHolder)
      end
    end

    describe "GET edit" do
      it "assigns the requested copyright_holder as @copyright_holder" do
        copyright_holder = CopyrightHolder.create! valid_attributes
        get :edit, {:id => copyright_holder.to_param}, valid_session
        assigns(:copyright_holder).should eq(copyright_holder)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new CopyrightHolder" do
          expect {
            post :create, {:copyright_holder => valid_attributes}, valid_session
          }.to change(CopyrightHolder, :count).by(1)
        end

        it "assigns a newly created copyright_holder as @copyright_holder" do
          post :create, {:copyright_holder => valid_attributes}, valid_session
          assigns(:copyright_holder).should be_a(CopyrightHolder)
          assigns(:copyright_holder).should be_persisted
        end

        it "redirects to the created copyright_holder" do
          post :create, {:copyright_holder => valid_attributes}, valid_session
          response.should redirect_to(CopyrightHolder.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved copyright_holder as @copyright_holder" do
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolder.any_instance.stub(:save).and_return(false)
          post :create, {:copyright_holder => { "number" => "invalid value" }}, valid_session
          assigns(:copyright_holder).should be_a_new(CopyrightHolder)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolder.any_instance.stub(:save).and_return(false)
          post :create, {:copyright_holder => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested copyright_holder" do
          copyright_holder = CopyrightHolder.create! valid_attributes
          # Assuming there are no other copyright_holders in the database, this
          # specifies that the CopyrightHolder created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          CopyrightHolder.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => copyright_holder.to_param, :copyright_holder => { "number" => "1" }}, valid_session
        end

        it "assigns the requested copyright_holder as @copyright_holder" do
          copyright_holder = CopyrightHolder.create! valid_attributes
          put :update, {:id => copyright_holder.to_param, :copyright_holder => valid_attributes}, valid_session
          assigns(:copyright_holder).should eq(copyright_holder)
        end

        it "redirects to the copyright_holder" do
          copyright_holder = CopyrightHolder.create! valid_attributes
          put :update, {:id => copyright_holder.to_param, :copyright_holder => valid_attributes}, valid_session
          response.should redirect_to(copyright_holder)
        end
      end

      describe "with invalid params" do
        it "assigns the copyright_holder as @copyright_holder" do
          copyright_holder = CopyrightHolder.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolder.any_instance.stub(:save).and_return(false)
          put :update, {:id => copyright_holder.to_param, :copyright_holder => { "number" => "invalid value" }}, valid_session
          assigns(:copyright_holder).should eq(copyright_holder)
        end

        it "re-renders the 'edit' template" do
          copyright_holder = CopyrightHolder.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CopyrightHolder.any_instance.stub(:save).and_return(false)
          put :update, {:id => copyright_holder.to_param, :copyright_holder => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested copyright_holder" do
        copyright_holder = CopyrightHolder.create! valid_attributes
        expect {
          delete :destroy, {:id => copyright_holder.to_param}, valid_session
        }.to change(CopyrightHolder, :count).by(-1)
      end

      it "redirects to the copyright_holders list" do
        copyright_holder = CopyrightHolder.create! valid_attributes
        delete :destroy, {:id => copyright_holder.to_param}, valid_session
        response.should redirect_to(copyright_holders_url)
      end
    end

  end
end
