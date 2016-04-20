require 'rails_helper'

RSpec.describe TermTag, type: :model do
  subject { FactoryGirl.create :term_tag }

  it { is_expected.to belong_to(:term) }
  it { is_expected.to belong_to(:tag) }

  it { is_expected.to validate_presence_of(:term) }
  it { is_expected.to validate_presence_of(:tag) }

  it { is_expected.to validate_uniqueness_of(:tag).scoped_to(:term_id) }
end
