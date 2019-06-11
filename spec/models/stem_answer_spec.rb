require "rails_helper"

RSpec.describe StemAnswer, type: :model do

  subject(:stem_answer) { FactoryBot.create(:stem_answer) }

  it { is_expected.to belong_to(:stem) }
  it { is_expected.to belong_to(:answer) }

  it { is_expected.to validate_presence_of(:correctness) }

  it { is_expected.to validate_uniqueness_of(:answer).scoped_to(:stem_id) }

  it { is_expected.to validate_numericality_of(:correctness).is_greater_than_or_equal_to(0.0)
                                                            .is_less_than_or_equal_to(1.0) }

  it 'requires that the stem and answer belong to the same question' do
    sa = FactoryBot.build(:stem_answer, stem: FactoryBot.build(:stem),
                                         answer: FactoryBot.build(:answer))
    expect(sa).not_to be_valid
    expect(sa.errors[:answer]).to(
      include('must belong to the same question as the stem'))

    sa.answer.question = sa.stem.question
    expect(sa).to be_valid
  end

end
