require 'rails_helper'

RSpec.describe Dev::UsersGenerate do
  let!(:contract) { FactoryBot.create :fine_print_contract, :published }

  let(:count)     { 2 }

  let(:params)    { { generate: { count: count } } }

  it 'creates a user based on the given params' do
    expect do
      described_class.handle params: params
    end.to  change { User.count }.by(count)
       .and change { FinePrint::Signature.count }.by(count * FinePrint::Contract.published.count)

    User.order(:created_at).last(count).each { |user| expect(contract.signed_by?(user)).to eq true }
  end
end
