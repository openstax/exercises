require "rails_helper"

RSpec.describe Styling, :type => :model do

  subject { FactoryGirl.create(:styling) }

  it { is_expected.to belong_to(:stylable) }

  it { is_expected.to validate_presence_of(:stylable) }
  it { is_expected.to validate_presence_of(:style) }

  it { is_expected.to validate_inclusion_of(:style).in_array(Style.all) }

  xit 'requires a unique style for each stylable' do
  end

end
