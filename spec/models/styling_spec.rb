require "rails_helper"

RSpec.describe Styling, type: :model do

  it { is_expected.to belong_to(:stylable) }

  it { is_expected.to validate_presence_of(:style) }

  it { is_expected.to validate_inclusion_of(:style).in_array(Style.all) }

  it 'requires a unique style for each stylable' do
    styling_1 = FactoryBot.create :styling
    styling_2 = FactoryBot.build :styling, stylable: styling_1.stylable,
                                           style: styling_1.style
    expect(styling_2).not_to be_valid
    expect(styling_2.errors[:style]).to include('has already been taken')

    styling_2.style = Style::DRAWING
    expect(styling_2).to be_valid

    styling_2.style = Style::FREE_RESPONSE
    expect(styling_2).not_to be_valid

    styling_2.stylable = FactoryBot.build :stem, styles: []
    expect(styling_2).to be_valid
  end

end
