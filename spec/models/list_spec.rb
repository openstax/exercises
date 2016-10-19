require "rails_helper"

RSpec.describe List, type: :model do

  it { is_expected.to have_one(:parent_list_nesting) }
  it { is_expected.to have_many(:child_list_nestings) }

  it { is_expected.to have_many(:list_owners).dependent(:destroy) }
  it { is_expected.to have_many(:list_editors).dependent(:destroy) }
  it { is_expected.to have_many(:list_readers).dependent(:destroy) }

  it { is_expected.to have_many(:list_publication_groups).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }

end
