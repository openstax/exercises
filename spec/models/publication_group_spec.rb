require 'rails_helper'

RSpec.describe PublicationGroup, type: :model do

  subject(:publication_group) { FactoryBot.create :publication_group }

  it { is_expected.to have_many(:publications).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:publishable_type) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_presence_of(:number) }

  it { is_expected.to validate_uniqueness_of(:uuid) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:publishable_type) }

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

  it 'is readonly after creation' do
    publication_group = FactoryBot.build :publication_group
    expect(publication_group).not_to be_readonly
    publication_group.save!
    expect(publication_group).to be_readonly
  end

end
