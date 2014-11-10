require 'rails_helper'

RSpec.describe CopyrightHolder, :type => :model do

  it { is_expected.to belong_to(:publication) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:publication) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_uniqueness_of(:user)
                        .scoped_to(:publication_id) }

  it { is_expected.to delegate_method(:name).to(:user) }

end
