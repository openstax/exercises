require "rails_helper"

RSpec.describe Attachment, type: :model do

  subject(:attachment) { FactoryBot.create :attachment }
  let(:asset_path)     { attachment.asset.path }

  after(:each) { attachment.destroy }

  it { is_expected.to belong_to(:parent) }

  it { is_expected.to validate_presence_of(:parent) }

  it 'requires a unique asset for each parent' do
    attachment_2 = FactoryBot.build :attachment, parent: attachment.parent, asset: nil
    expect(attachment_2).not_to be_valid
    expect(attachment_2.errors[:asset]).to include("can't be blank")

    attachment_2.asset = attachment.asset
    expect(attachment_2).not_to be_valid
    expect(attachment_2.errors[:asset]).to include 'has already been associated with this resource'

    attachment_2.parent = FactoryBot.build :exercise
    expect(attachment_2).to be_valid

    attachment_2.parent = attachment.parent
    expect(attachment_2).not_to be_valid

    attachment_2.asset = File.open('spec/fixtures/rails.png')
    expect(attachment_2).to be_valid
  end

  it 'raises ActiveRecord::ReadOnlyRecord on update' do
    attachment.asset = File.open('spec/fixtures/rails.png')
    expect{ attachment.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  context 'on destroy' do
    it 'does not remove the asset when there are other references left' do
      attachment_2 = FactoryBot.create :attachment, asset: attachment.asset
      attachment_2.destroy

      expect(File.exist?(asset_path)).to eq true
    end

    it 'removes the asset when there are no references left' do
      attachment.destroy

      expect(File.exist?(asset_path)).to eq false
    end
  end

end
