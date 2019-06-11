require "rails_helper"

RSpec.describe Stem, type: :model do

  it { is_expected.to belong_to(:question) }

  it { is_expected.to have_many(:stem_answers).dependent(:destroy) }

  it { is_expected.to have_many(:combo_choices).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:content) }

end
