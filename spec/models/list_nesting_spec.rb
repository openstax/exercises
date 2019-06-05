require "rails_helper"

RSpec.describe ListNesting, type: :model do

  subject(:list_nesting) { FactoryBot.create(:list_nesting) }

  it { is_expected.to belong_to(:parent_list) }
  it { is_expected.to belong_to(:child_list) }

  it { is_expected.to validate_uniqueness_of(:child_list) }

end
