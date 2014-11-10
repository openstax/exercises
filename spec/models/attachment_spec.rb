require "rails_helper"

RSpec.describe Attachment, :type => :model do

  it { is_expected.to belong_to(:parent) }

  it { is_expected.to validate_presence_of(:parent) }
  it { is_expected.to validate_presence_of(:asset) }
  it { is_expected.to validate_uniqueness_of(:asset)
                        .scoped_to(:parent_id, :parent_type) }

end
