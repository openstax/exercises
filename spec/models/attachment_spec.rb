require "rails_helper"

RSpec.describe Attachment, type: :model do
  subject(:attachment) { FactoryBot.create :attachment }
  let(:asset_path)     { attachment.asset }

  after(:each) { attachment.destroy }

  it { is_expected.to belong_to(:parent) }

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

    attachment_2.asset = 'spec/fixtures/rails.png'
    expect(attachment_2).to be_valid
  end

  it 'raises ActiveRecord::ReadOnlyRecord on update' do
    attachment.asset = 'spec/fixtures/rails.png'
    expect{ attachment.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "updates the parent record's timestamp when it is created or destroyed" do
    parent = attachment.parent

    expect { attachment.destroy! }.to change { parent.reload.updated_at }

    expect { FactoryBot.create :attachment, parent: parent }.to change { parent.reload.updated_at }
  end
end
