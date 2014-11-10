require "rails_helper"

RSpec.describe Deputization, :type => :model do

  it { is_expected.to belong_to(:deputy) }
  it { is_expected.to belong_to(:deputizer) }

  it { is_expected.to validate_presence_of(:deputy) }
  it { is_expected.to validate_presence_of(:deputizer) }
  it { is_expected.to validate_uniqueness_of(:deputizer)
                        .scoped_to(:deputy_id, :deputy_type) }

end
