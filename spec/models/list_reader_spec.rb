require "rails_helper"

RSpec.describe ListReader, type: :model do

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:reader) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:reader) }

  it 'requires a unique reader for each list' do
    list_reader_1 = FactoryGirl.create :list_reader
    list_reader_2 = FactoryGirl.build :list_reader,
                                      list: list_reader_1.list,
                                      reader: list_reader_1.reader
    expect(list_reader_2).not_to be_valid
    expect(list_reader_2.errors[:list]).to(
      include('has already been taken'))

    list_reader_2.list = FactoryGirl.build :list
    expect(list_reader_2).to be_valid

    list_reader_2.list = list_reader_1.list
    expect(list_reader_2).not_to be_valid

    list_reader_2.reader = FactoryGirl.build :user
    expect(list_reader_2).to be_valid
  end

end
