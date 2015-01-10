require "rails_helper"

RSpec.describe StemAnswer, :type => :model do

  subject { FactoryGirl.create(:stem_answer) }

  it { is_expected.to belong_to(:stem) }
  it { is_expected.to belong_to(:answer) }

  it { is_expected.to validate_presence_of(:stem) }
  it { is_expected.to validate_presence_of(:answer) }
  it { is_expected.to validate_presence_of(:correctness) }

  it { is_expected.to validate_uniqueness_of(:answer).scoped_to(:stem_id) }

  it { is_expected.to validate_numericality_of(:correctness) }

  xit 'requires that the stem and answer belong to the same question' do
  end

end
