require 'rails_helper'

RSpec.describe LogicVariable, type: :model do

  INVALID_VARIABLES = ["'hello'", '"hello"', 'hel lo', '$hello$', '<hello>',
                       'hello?', 'http://hello', '/hel/lo', 'hel; lo']

  subject(:logic_variable) { FactoryBot.create(:logic_variable) }

  it { is_expected.to belong_to(:logic) }

  it { is_expected.to have_many(:logic_variable_values).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:variable) }

  it { is_expected.to validate_uniqueness_of(:variable).scoped_to(:logic_id) }

  it { is_expected.to validate_exclusion_of(:variable).in_array(LogicVariable::RESERVED_WORDS) }

  it 'validates the format of its variable' do
    lv = FactoryBot.build(:logic_variable)
    expect(lv).to be_valid

    lv.variable = 'hello'
    expect(lv).to be_valid

    INVALID_VARIABLES.each do |variable|
      lv.variable = variable
      expect(lv).not_to be_valid
      expect(lv.errors[:variable]).to include('is invalid')
    end

    LogicVariable::RESERVED_WORDS.each do |word|
      lv.variable = word
      expect(lv).not_to be_valid
      expect(lv.errors[:variable]).to include('is reserved')
    end
  end

end
