require "rails_helper"

RSpec.describe LogicVariableValue, type: :model do

  subject(:logic_variable_value) { FactoryBot.create(:logic_variable_value) }

  it { is_expected.to belong_to(:logic_variable) }

  it { is_expected.to validate_presence_of(:seed) }
  it { is_expected.to validate_presence_of(:value) }

  it { is_expected.to validate_uniqueness_of(:seed).scoped_to(:logic_variable_id) }

end
