require "rails_helper"

RSpec.describe Publication, type: :model do

  subject(:publication) { FactoryBot.create :publication }

  it { is_expected.to belong_to(:publication_group) }
  it { is_expected.to belong_to(:publishable) }
  it { is_expected.to belong_to(:license).optional }

  it { is_expected.to have_many(:authors).dependent(:destroy) }
  it { is_expected.to have_many(:copyright_holders).dependent(:destroy) }

  it { is_expected.to have_many(:sources).dependent(:destroy) }
  it { is_expected.to have_many(:derivations).dependent(:destroy) }

  it { is_expected.to validate_uniqueness_of(:uuid).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:version).scoped_to(:publication_group_id) }

  it { is_expected.to validate_numericality_of(:version).only_integer.is_greater_than(0) }

  it 'requires a unique publishable' do
    publication_2 = FactoryBot.build :publication, publishable: publication.publishable
    expect(publication_2).not_to be_valid
    expect(publication_2.errors[:publishable_id]).to include 'has already been taken'

    publication_2.publishable = FactoryBot.build :exercise
    expect(publication_2).to be_valid
  end

  it 'requires a valid license or nil' do
    expect(publication).to be_valid

    publication.license = FactoryBot.build :license, licensed_classes: []
    expect(publication).not_to be_valid
    expect(publication.errors[:license]).to include 'is invalid for Exercise'

    publication.license = nil
    expect(publication).to be_valid
  end

  it 'automatically assigns uuid, group_uuid, number and version on creation' do
    p = Exercise.create.publication
    expect(p).to be_valid
    expect(p.uuid).to be_a String
    expect(p.group_uuid).to be_a String
    expect(p.number).to be > 0
    expect(p.version).to eq 1
    expect(p.uid).to eq "#{p.number}@1"


    p_2 = FactoryBot.create :publication, number: p.number
    expect(p_2).to be_valid
    expect(p.uuid).to be_a String
    expect(p.group_uuid).to be_a String
    expect(p_2.number).to eq p.number
    expect(p_2.version).to eq 2
    expect(p_2.uid).to eq "#{p.number}@2"
  end

  it 'knows its own status' do
    expect(publication.is_published?).to eq false
    expect(publication.is_embargoed?).to eq false
    expect(publication.is_yanked?).to eq false
    expect(publication.is_public?).to eq false

    publication.published_at = Time.now
    publication.embargoed_until = Time.now + 1.year
    expect(publication.is_published?).to eq true
    expect(publication.is_embargoed?).to eq true
    expect(publication.is_yanked?).to eq false
    expect(publication.is_public?).to eq false

    publication.embargoed_until = Time.now - 1.day
    expect(publication.is_published?).to eq true
    expect(publication.is_embargoed?).to eq false
    expect(publication.is_yanked?).to eq false
    expect(publication.is_public?).to eq true

    publication.yanked_at = Time.now
    expect(publication.is_published?).to eq true
    expect(publication.is_embargoed?).to eq false
    expect(publication.is_yanked?).to eq true
    expect(publication.is_public?).to eq false
  end

  it 'can set itself to published' do
    expect(publication.is_published?).to eq false
    publication.publish
    expect(publication.is_published?).to eq true
  end

  it 'validates the publishable before publication' do
    expect(publication.reload.publishable).to receive(:before_publication) do
      publication.publishable.errors.add(:base, 'is invalid')
      throw :abort
    end
    expect(publication.publish.save).to eq false
    expect(publication.errors.first).to eq [:exercise, 'is invalid']

    expect(publication.reload.publishable).to receive(:before_publication)
    expect(publication.publish.save).to eq true
  end

  it 'updates the publication_group\'s latest_version after creation' +
     ' and latest_published_version after publication' do
    expect(publication.publication_group.latest_version).to eq publication.version
    expect(publication.publication_group.latest_published_version).to be_nil
    publication.publish.save
    expect(publication.publication_group.latest_version).to eq publication.version
    expect(publication.publication_group.latest_published_version).to eq publication.version
    new_version = publication.publishable.new_version.publication
    new_version.save
    expect(publication.publication_group.reload.latest_version).to eq new_version.version
    expect(publication.publication_group.latest_published_version).to eq publication.version
  end

end
