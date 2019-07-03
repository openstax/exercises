require "rails_helper"

RSpec.describe User, type: :model do

  subject(:user) { FactoryBot.create :user }

  it { is_expected.to belong_to(:account) }

  it { is_expected.to have_one(:administrator).dependent(:destroy) }

  it { is_expected.to have_many(:groups_as_member) }
  it { is_expected.to have_many(:groups_as_owner) }

  it { is_expected.to have_many(:authors).dependent(:destroy) }
  it { is_expected.to have_many(:copyright_holders).dependent(:destroy) }

  it { is_expected.to have_many(:delegations_as_delegator).dependent(:destroy) }
  it { is_expected.to have_many(:delegations_as_delegate).dependent(:destroy)  }

  it { is_expected.to have_many(:direct_list_owners).dependent(:destroy) }
  it { is_expected.to have_many(:direct_list_editors).dependent(:destroy) }
  it { is_expected.to have_many(:direct_list_readers).dependent(:destroy) }

  it { is_expected.to have_many(:direct_applications).dependent(:destroy) }

  it { is_expected.to validate_uniqueness_of(:account) }

  [ :username, :first_name, :last_name, :full_name,
    :title, :name, :casual_name, :uuid, :support_identifier ].each do |method|
    it { is_expected.to delegate_method(method).to(:account) }
  end

  [ :first_name=, :last_name=, :full_name=, :title= ].each do |method|
    it { is_expected.to delegate_method(method).to(:account).with_arguments('test') }
  end

  context 'instance' do
    it 'is a human' do
      expect(user.is_human?).to eq true
    end

    it 'is not an application' do
      expect(user.is_application?).to eq false
    end

    it 'does not start deleted' do
      expect(user.is_deleted?).to eq false
    end

    it 'still exists after deletion' do
      id = user.id
      user.delete
      expect(User.where(id: id)).to exist
      expect(user.is_deleted?).to eq true
    end

    it 'still exists after destroy' do
      id = user.id
      user.destroy
      expect(User.where(id: id)).to exist
      expect(user.is_deleted?).to eq true
    end

    it 'can be undeleted' do
      id = user.id
      user.destroy
      expect(user.is_deleted?).to eq true
      user.undelete
      expect(user.is_deleted?).to eq false
    end
  end
end
