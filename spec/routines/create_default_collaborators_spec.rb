require 'rails_helper'

RSpec.describe CreateDefaultCollaborators do
  it 'creates the OpenStax and Rice University users' do
    result = nil
    expect{
      result = CreateDefaultCollaborators.call
    }.to change{ User.count }.by(2)
    expect(result.errors).to be_empty

    expect(result.outputs.author.username).to eq 'openstax'
    expect(result.outputs.author.full_name).to eq 'OpenStax'

    expect(result.outputs.copyright_holder.username).to eq 'rice_university'
    expect(result.outputs.copyright_holder.full_name).to eq 'Rice University'
  end
end
