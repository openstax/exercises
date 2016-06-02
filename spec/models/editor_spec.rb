require "rails_helper"

RSpec.describe Editor, type: :model do

  subject!(:editor) { FactoryGirl.create(:editor) }

  it { is_expected.to belong_to(:publication) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:publication) }
  it { is_expected.to validate_presence_of(:user) }

  it { is_expected.to delegate_method(:name).to(:user) }

  it 'requires a unique user for each publication' do
    editor_2 = FactoryGirl.build :editor, user: editor.user, publication: editor.publication
    expect(editor_2).not_to be_valid
    expect(editor_2.errors[:user]).to include 'has already been taken'
  end

end
