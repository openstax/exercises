require 'rails_helper'

RSpec.describe ListPublicationGroup, type: :model do

  subject(:list_publication_group) { FactoryBot.create :list_publication_group }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:publication_group) }

  it { is_expected.to validate_uniqueness_of(:publication_group).scoped_to(:list_id) }

end
