require "rails_helper"

RSpec.describe Logic, type: :model do

  it { is_expected.to belong_to(:parent) }

  it { is_expected.to have_many(:logic_variables) }

  it { is_expected.to validate_presence_of(:language) }
  it { is_expected.to validate_presence_of(:code) }

  it { is_expected.to validate_inclusion_of(:language).in_array(Language.all) }

  it 'requires a unique parent' do
    logic_1 = FactoryBot.create :logic
    logic_2 = FactoryBot.build :logic, parent: logic_1.parent
    expect(logic_2).not_to be_valid
    expect(logic_2.errors[:parent_id]).to(
      include('has already been taken'))

    logic_2.parent = FactoryBot.build :exercise
    expect(logic_2).to be_valid
  end

end
