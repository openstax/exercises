require "rails_helper"

RSpec.describe Question, type: :model do

  it { is_expected.to have_many(:stems).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:solutions).dependent(:destroy) }

  it { is_expected.to have_many(:hints).dependent(:destroy) }

  it { is_expected.to have_many(:parent_dependencies).dependent(:destroy) }
  it { is_expected.to have_many(:child_dependencies).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:exercise) }

end
