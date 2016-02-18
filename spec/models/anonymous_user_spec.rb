require "rails_helper"

RSpec.describe AnonymousUser, type: :model do

  it 'is a singleton' do
    expect(AnonymousUser).to respond_to(:instance)
    expect(AnonymousUser.instance).to be_a AnonymousUser
  end

  it 'is anonymous' do
    anon = AnonymousUser.instance
    expect(anon.id).to be_nil
    expect(anon.account).to eq(OpenStax::Accounts::AnonymousAccount.instance)
    expect(anon.account_id).to be_nil
    expect(anon.username).to eq 'Anonymous'
    expect(anon.is_anonymous?).to eq true
    expect(anon.is_deleted?).to eq false
  end

end
