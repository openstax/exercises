require 'spec_helper'

describe "FillInTheBlankAnswers" do
  describe "GET /fill_in_the_blank_answers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get fill_in_the_blank_answers_path
      response.status.should be(200)
    end
  end
end
