require "rails_helper"

RSpec.describe ComboChoiceAnswer, type: :model do

  subject(:combo_choice_answer) { FactoryBot.create :combo_choice_answer }

  it { is_expected.to belong_to(:combo_choice) }
  it { is_expected.to belong_to(:answer) }

  it { is_expected.to validate_uniqueness_of(:answer).scoped_to(:combo_choice_id) }

  it 'should require answer and combo_choice to have the same question' do
    cca = FactoryBot.build(:combo_choice_answer, answer: FactoryBot.build(:answer))
    expect(cca).not_to be_valid
    expect(cca.errors[:answer]).to include 'must belong to the same question as the combo choice'
  end

end
