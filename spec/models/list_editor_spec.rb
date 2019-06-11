require "rails_helper"

RSpec.describe ListEditor, type: :model do

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:editor) }

  it 'requires a unique editor for each list' do
    list_editor_1 = FactoryBot.create :list_editor
    list_editor_2 = FactoryBot.build :list_editor,
                                      list: list_editor_1.list,
                                      editor: list_editor_1.editor
    expect(list_editor_2).not_to be_valid
    expect(list_editor_2.errors[:list]).to(
      include('has already been taken'))

    list_editor_2.list = FactoryBot.build :list
    expect(list_editor_2).to be_valid

    list_editor_2.list = list_editor_1.list
    expect(list_editor_2).not_to be_valid

    list_editor_2.editor = FactoryBot.build :user
    expect(list_editor_2).to be_valid
  end

end
