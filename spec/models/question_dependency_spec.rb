require "rails_helper"

RSpec.describe QuestionDependency, type: :model do

  subject(:question_dependency) { FactoryGirl.create(:question_dependency) }

  it { is_expected.to belong_to(:parent_question) }
  it { is_expected.to belong_to(:dependent_question) }

  it { is_expected.to validate_presence_of(:parent_question) }
  it { is_expected.to validate_presence_of(:dependent_question) }

  it { is_expected.to validate_uniqueness_of(:dependent_question).scoped_to(:parent_question_id) }

  it 'requires both questions to belong to the same exercise' do
    qd = FactoryGirl.build(:question_dependency,
                           parent_question: FactoryGirl.build(:question),
                           dependent_question: FactoryGirl.build(:question))
    expect(qd).not_to be_valid
    expect(qd.errors[:dependent_question]).to(
      include('must belong to the same exercise as the parent question'))

    qd.dependent_question.exercise = qd.parent_question.exercise
    expect(qd).to be_valid
  end

end
