require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController, type: :controller, api: true, version: :v1 do

    # This should return the minimal set of attributes required to create a valid
    # Publication. As you add validations to Publication, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { "number" => "1" } }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PublicationsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all publications as @publications" do
        publication = Publication.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:publications)).to eq([publication])
      end
    end

    describe "GET show" do
      it "assigns the requested publication as @publication" do
        publication = Publication.create! valid_attributes
        get :show, {:id => publication.to_param}, valid_session
        expect(assigns(:publication)).to eq(publication)
      end
    end

    describe "GET new" do
      it "assigns a new publication as @publication" do
        get :new, {}, valid_session
        expect(assigns(:publication)).to be_a_new(Publication)
      end
    end

    describe "GET edit" do
      it "assigns the requested publication as @publication" do
        publication = Publication.create! valid_attributes
        get :edit, {:id => publication.to_param}, valid_session
        expect(assigns(:publication)).to eq(publication)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Publication" do
          expect {
            post :create, {:publication => valid_attributes}, valid_session
          }.to change(Publication, :count).by(1)
        end

        it "assigns a newly created publication as @publication" do
          post :create, {:publication => valid_attributes}, valid_session
          expect(assigns(:publication)).to be_a(Publication)
          expect(assigns(:publication)).to be_persisted
        end

        it "redirects to the created publication" do
          post :create, {:publication => valid_attributes}, valid_session
          expect(response).to redirect_to(Publication.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved publication as @publication" do
          # Trigger the behavior that occurs when invalid params are submitted
          Publication.any_instance.stub(:save).and_return(false)
          post :create, {:publication => { "number" => "invalid value" }}, valid_session
          expect(assigns(:publication)).to be_a_new(Publication)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Publication.any_instance.stub(:save).and_return(false)
          post :create, {:publication => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested publication" do
          publication = Publication.create! valid_attributes
          # Assuming there are no other publications in the database, this
          # specifies that the Publication created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          expect(Publication.any_instance).to_receive(:update_attributes).with({ "number" => "1" })
          put :update, {:id => publication.to_param, :publication => { "number" => "1" }}, valid_session
        end

        it "assigns the requested publication as @publication" do
          publication = Publication.create! valid_attributes
          put :update, {:id => publication.to_param, :publication => valid_attributes}, valid_session
          expect(assigns(:publication)).to eq(publication)
        end

        it "redirects to the publication" do
          publication = Publication.create! valid_attributes
          put :update, {:id => publication.to_param, :publication => valid_attributes}, valid_session
          expect(response).to redirect_to(publication)
        end
      end

      describe "with invalid params" do
        it "assigns the publication as @publication" do
          publication = Publication.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Publication.any_instance.stub(:save).and_return(false)
          put :update, {:id => publication.to_param, :publication => { "number" => "invalid value" }}, valid_session
          expect(assigns(:publication)).to eq(publication)
        end

        it "re-renders the 'edit' template" do
          publication = Publication.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Publication.any_instance.stub(:save).and_return(false)
          put :update, {:id => publication.to_param, :publication => { "number" => "invalid value" }}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested publication" do
        publication = Publication.create! valid_attributes
        expect {
          delete :destroy, {:id => publication.to_param}, valid_session
        }.to change(Publication, :count).by(-1)
      end

      it "redirects to the publications list" do
        publication = Publication.create! valid_attributes
        delete :destroy, {:id => publication.to_param}, valid_session
        expect(response).to redirect_to(publications_url)
      end
    end

  end
end
