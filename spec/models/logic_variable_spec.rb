require 'rails_helper'

RSpec.describe LogicVariable, :type => :model do

  it { is_expected.to belong_to(:logic) }

  it { is_expected.to have_many(:logic_variable_values).dependent(:destroy) }

  xit 'ensures the variables are well formatted' do
  end

end
