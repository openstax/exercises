require 'rails_helper'

RSpec.describe Hint, type: :model do

  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of(:content) }

end
