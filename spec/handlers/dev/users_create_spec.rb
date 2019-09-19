require 'rails_helper'

RSpec.describe Dev::UsersCreate do
  let!(:contract)        { FactoryBot.create :fine_print_contract, :published }

  let(:username)         { 'bob' }
  let(:first_name)       { 'Bob' }
  let(:last_name)        { 'Marley' }
  let(:full_name)        { 'Marley, Bob' }
  let(:title)            { 'Mr.' }
  let(:is_administrator) { true }
  let(:agreed_to_terms)  { true }

  let(:params) do
    {
      create: {
        username: username,
        first_name: first_name,
        last_name: last_name,
        full_name: full_name,
        title: title,
        is_administrator: is_administrator,
        agreed_to_terms: agreed_to_terms
      }
    }
  end

  it 'creates a user based on the given params' do
    expect do
      described_class.handle params: params
    end.to  change { User.count }.by(1)
       .and change { FinePrint::Signature.count }.by(FinePrint::Contract.published.count)

    user = User.order(:created_at).last

    expect(user.username).to eq username
    expect(user.first_name).to eq first_name
    expect(user.last_name).to eq last_name
    expect(user.full_name).to eq full_name
    expect(user.title).to eq title
    expect(user).to be_is_administrator
    expect(contract.signed_by?(user)).to eq true
  end
end
