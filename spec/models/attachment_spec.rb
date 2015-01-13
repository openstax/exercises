require "rails_helper"

RSpec.describe Attachment, :type => :model do

  it { is_expected.to belong_to(:parent) }

  it { is_expected.to validate_presence_of(:parent) }
  it { is_expected.to validate_presence_of(:asset) }

  it 'requires a unique asset for each parent' do
    attachment_1 = FactoryGirl.create :attachment
    attachment_2 = FactoryGirl.build :attachment, parent: attachment_1.parent,
                                                  asset: attachment_1.asset
    expect(attachment_2).not_to be_valid
    expect(attachment_2.errors[:asset]).to include('has already been taken')

    attachment_2.parent = FactoryGirl.build :exercise
    expect(attachment_2).to be_valid

    attachment_2.parent = attachment_1.parent
    expect(attachment_2).not_to be_valid

    attachment_2.asset = SecureRandom.hex
    expect(attachment_2).to be_valid
  end

end
