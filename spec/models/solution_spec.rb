require "rails_helper"

RSpec.describe Solution, :type => :model do

  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of(:question) }

end
