require "rails_helper"

RSpec.describe ListEditor, :type => :model do

  subject { FactoryGirl.create(:list_editor) }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:editor) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:editor) }

  it { is_expected.to validate_uniqueness_of(:editor).scoped_to(:list_id) }

end
