require "rails_helper"

RSpec.describe ComboChoiceAnswer, :type => :model do

  subject { FactoryGirl.create(:combo_choice_answer) }

  it { is_expected.to belong_to(:combo_choice) }
  it { is_expected.to belong_to(:answer) }

  it { is_expected.to validate_presence_of(:combo_choice) }
  it { is_expected.to validate_presence_of(:answer) }

  it { is_expected.to validate_uniqueness_of(:answer)
                        .scoped_to(:combo_choice_id) }

  it 'should require answer and combo_choice to have the same question' do
    cca = FactoryGirl.build(:combo_choice_answer,
                            answer: FactoryGirl.build(:answer))
    expect(cca).not_to be_valid
    expect(cca.errors[:answer]).to include(
      'must belong to the same question as the combo choice')
  end

end
