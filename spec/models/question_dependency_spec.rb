require "rails_helper"

RSpec.describe QuestionDependency, :type => :model do

  subject { FactoryGirl.create(:question_dependency) }

  it { is_expected.to belong_to(:parent_question) }
  it { is_expected.to belong_to(:dependent_question) }

  it { is_expected.to validate_presence_of(:parent_question) }
  it { is_expected.to validate_presence_of(:dependent_question) }

  it { is_expected.to validate_uniqueness_of(:dependent_question)
                        .scoped_to(:parent_question_id) }

  xit 'requires both questions to belong to the same exercise' do
  end

end
