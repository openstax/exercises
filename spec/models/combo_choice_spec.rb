require "rails_helper"

RSpec.describe ComboChoice, type: :model do

  it { is_expected.to belong_to(:stem) }

  it { is_expected.to have_many(:combo_choice_answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:correctness) }

  it { is_expected.to validate_numericality_of(:correctness) }

end
