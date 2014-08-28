require "rails_helper"

module Api::V1
  RSpec.describe PartDependenciesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # PartDependency. As you add validations to PartDependency, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PartDependenciesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all part_dependencies as @part_dependencies" do
        part_dependency = PartDependency.create! valid_attributes
        get :index, {}, valid_session
        assigns(:part_dependencies).should eq([part_dependency])
      end
    end

    describe "GET show" do
      it "assigns the requested part_dependency as @part_dependency" do
        part_dependency = PartDependency.create! valid_attributes
        get :show, {:id => part_dependency.to_param}, valid_session
        assigns(:part_dependency).should eq(part_dependency)
      end
    end

    describe "GET new" do
      it "assigns a new part_dependency as @part_dependency" do
        get :new, {}, valid_session
        assigns(:part_dependency).should be_a_new(PartDependency)
      end
    end

    describe "GET edit" do
      it "assigns the requested part_dependency as @part_dependency" do
        part_dependency = PartDependency.create! valid_attributes
        get :edit, {:id => part_dependency.to_param}, valid_session
        assigns(:part_dependency).should eq(part_dependency)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new PartDependency" do
          expect {
            post :create, {:part_dependency => valid_attributes}, valid_session
          }.to change(PartDependency, :count).by(1)
        end

        it "assigns a newly created part_dependency as @part_dependency" do
          post :create, {:part_dependency => valid_attributes}, valid_session
          assigns(:part_dependency).should be_a(PartDependency)
          assigns(:part_dependency).should be_persisted
        end

        it "redirects to the created part_dependency" do
          post :create, {:part_dependency => valid_attributes}, valid_session
          response.should redirect_to(PartDependency.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved part_dependency as @part_dependency" do
          # Trigger the behavior that occurs when invalid params are submitted
          PartDependency.any_instance.stub(:save).and_return(false)
          post :create, {:part_dependency => { "number" => "invalid value" }}, valid_session
          assigns(:part_dependency).should be_a_new(PartDependency)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          PartDependency.any_instance.stub(:save).and_return(false)
          post :create, {:part_dependency => { "number" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested part_dependency" do
          part_dependency = PartDependency.create! valid_attributes
          # Assuming there are no other part_dependencies in the database, this
          # specifies that the PartDependency created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          PartDependency.any_instance.should_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => part_dependency.to_param, :part_dependency => { "number" => "1" }}, valid_session
        end

        it "assigns the requested part_dependency as @part_dependency" do
          part_dependency = PartDependency.create! valid_attributes
          put :update, {:id => part_dependency.to_param, :part_dependency => valid_attributes}, valid_session
          assigns(:part_dependency).should eq(part_dependency)
        end

        it "redirects to the part_dependency" do
          part_dependency = PartDependency.create! valid_attributes
          put :update, {:id => part_dependency.to_param, :part_dependency => valid_attributes}, valid_session
          response.should redirect_to(part_dependency)
        end
      end

      describe "with invalid params" do
        it "assigns the part_dependency as @part_dependency" do
          part_dependency = PartDependency.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          PartDependency.any_instance.stub(:save).and_return(false)
          put :update, {:id => part_dependency.to_param, :part_dependency => { "number" => "invalid value" }}, valid_session
          assigns(:part_dependency).should eq(part_dependency)
        end

        it "re-renders the 'edit' template" do
          part_dependency = PartDependency.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          PartDependency.any_instance.stub(:save).and_return(false)
          put :update, {:id => part_dependency.to_param, :part_dependency => { "number" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested part_dependency" do
        part_dependency = PartDependency.create! valid_attributes
        expect {
          delete :destroy, {:id => part_dependency.to_param}, valid_session
        }.to change(PartDependency, :count).by(-1)
      end

      it "redirects to the part_dependencies list" do
        part_dependency = PartDependency.create! valid_attributes
        delete :destroy, {:id => part_dependency.to_param}, valid_session
        response.should redirect_to(part_dependencies_url)
      end
    end

  end
end
