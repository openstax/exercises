require 'rails_helper'

RSpec.describe Author, type: :model do

  subject(:author) { FactoryBot.create(:author) }

  it { is_expected.to belong_to(:publication) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to delegate_method(:name).to(:user) }

  it 'requires a unique user for each publication' do
    author_2 = FactoryBot.build :author, user: author.user, publication: author.publication
    expect(author_2).not_to be_valid
    expect(author_2.errors[:user]).to include('has already been taken')
  end

end
