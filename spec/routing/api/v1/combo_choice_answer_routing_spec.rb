require "spec_helper"

module Api::V1
  describe ComboChoiceAnswersController do
    describe "routing" do

      it "routes to #index" do
        get("/combo_choice_answers").should route_to("combo_choice_answers#index")
      end

      it "routes to #new" do
        get("/combo_choice_answers/new").should route_to("combo_choice_answers#new")
      end

      it "routes to #show" do
        get("/combo_choice_answers/1").should route_to("combo_choice_answers#show", :id => "1")
      end

      it "routes to #edit" do
        get("/combo_choice_answers/1/edit").should route_to("combo_choice_answers#edit", :id => "1")
      end

      it "routes to #create" do
        post("/combo_choice_answers").should route_to("combo_choice_answers#create")
      end

      it "routes to #update" do
        put("/combo_choice_answers/1").should route_to("combo_choice_answers#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/combo_choice_answers/1").should route_to("combo_choice_answers#destroy", :id => "1")
      end

    end
  end
end
