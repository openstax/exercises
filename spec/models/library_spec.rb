require "rails_helper"

RSpec.describe Library, :type => :model do

  it { is_expected.to have_one(:required_library).dependent(:destroy) }
  it { is_expected.to have_many(:logic_libraries).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:language) }
  it { is_expected.to validate_inclusion_of(:language, in: Language.all) }

end
