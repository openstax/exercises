require 'rails_helper'

RSpec.describe PublicationGroup, type: :model do

  subject(:publication_group) { FactoryBot.create :publication_group }

  it { is_expected.to have_many(:publications) }

  it { is_expected.to validate_presence_of(:publishable_type) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:latest_version) }

  it { is_expected.to validate_uniqueness_of(:nickname).allow_nil }

  it { is_expected.to validate_numericality_of(:latest_version).only_integer.is_greater_than(0) }
  it do
    is_expected.to(
      validate_numericality_of(:latest_published_version).only_integer.is_greater_than(0).allow_nil
    )
  end

  it { is_expected.to validate_uniqueness_of(:uuid).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:publishable_type) }

  it { is_expected.to validate_numericality_of(:number).only_integer.is_greater_than(0) }

  it 'automatically assigns number and uuid on creation' do
    pg = Exercise.create.publication.publication_group
    expect(pg).to be_valid
    expect(pg.number).to be > 0
    expect(pg.uuid).not_to be_blank

    pg_2 = Exercise.create.publication.publication_group
    expect(pg_2).to be_valid
    expect(pg_2.number).to eq pg.number + 1
    expect(pg_2.uuid).not_to be_blank
    expect(pg_2.uuid).not_to eq pg.uuid
  end

  it 'defaults to ordering by number ASC' do
    publication_group_2 = FactoryBot.create :publication_group,
                                             number: publication_group.number + 1

    expect(PublicationGroup.all[-2..-1]).to(
      eq [publication_group.reload, publication_group_2.reload]
    )
  end

  it 'sets nickname to null when blank' do
    subject.update(nickname: '')
    expect(subject.reload.nickname).to be_nil
  end

end
