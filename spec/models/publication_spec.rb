require "rails_helper"

RSpec.describe Publication, type: :model do

  subject!(:publication) { FactoryGirl.create :publication }

  it { is_expected.to belong_to(:publication_group) }
  it { is_expected.to belong_to(:publishable) }
  it { is_expected.to belong_to(:license) }

  it { is_expected.to have_many(:authors).dependent(:destroy) }
  it { is_expected.to have_many(:copyright_holders).dependent(:destroy) }
  it { is_expected.to have_many(:editors).dependent(:destroy) }

  it { is_expected.to have_many(:sources).dependent(:destroy) }
  it { is_expected.to have_many(:derivations).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:publication_group) }
  it { is_expected.to validate_presence_of(:publishable) }
  it { is_expected.to validate_presence_of(:version) }

  it 'requires a unique publishable' do
    publication.save!
    publication_2 = FactoryGirl.build :publication, publishable: publication.publishable
    expect(publication_2).not_to be_valid
    expect(publication_2.errors[:publishable_id]).to include 'has already been taken'

    publication_2.publishable = FactoryGirl.build :exercise
    expect(publication_2).to be_valid
  end

  it 'requires a valid license or nil' do
    expect(publication).to be_valid

    publication.license = FactoryGirl.build :license, licensed_classes: []
    expect(publication).not_to be_valid
    expect(publication.errors[:license]).to include 'is invalid for Exercise'

    publication.license = nil
    expect(publication).to be_valid
  end

  it 'automatically assigns number and version on creation' do
    p = Exercise.create.publication
    expect(p).to be_valid
    expect(p.number).to be > 0
    expect(p.version).to eq 1
    expect(p.uid).to eq "#{p.number}@1"

    p_2 = FactoryGirl.create :publication, number: p.number
    expect(p_2).to be_valid
    expect(p_2.number).to eq p.number
    expect(p_2.version).to eq 2
    expect(p_2.uid).to eq "#{p.number}@2"
  end

  it 'defaults to ordering by number ASC and version DESC' do
    publication.save!
    publication_2 = FactoryGirl.create :publication,
                                       number: publication.number,
                                       version: publication.version + 1
    publication_3 = FactoryGirl.create :publication,
                                       number: publication.number + 1,
                                       version: publication.version
    publication_4 = FactoryGirl.create :publication,
                                       number: publication.number + 1,
                                       version: publication.version + 1
    expect(Publication.all[-4..-1]).to(
      eq [publication_2.reload, publication.reload,
          publication_4.reload, publication_3.reload]
    )
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
    publication.save!
    expect(publication.reload.publishable).to receive(:before_publication) do
      publication.publishable.errors.add(:base, 'is invalid')
      false
    end
    expect(publication.publish.save).to eq false
    expect(publication.errors.first).to eq [:exercise, 'is invalid']

    expect(publication.reload.publishable).to receive(:before_publication)
    expect(publication.publish.save).to eq true
  end

end
