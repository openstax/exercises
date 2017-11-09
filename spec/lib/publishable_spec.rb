require 'rails_helper'

RSpec.describe Publishable, type: :lib do
  pending "add more examples to #{__FILE__}"

  subject(:publishable) { FactoryBot.create :exercise }

  let(:author) { FactoryBot.create :user }
  let(:user)   { FactoryBot.create :user }

  before { publishable.authors << Author.new(user: author) }

  it 'can determine versions visible for a user' do
    p1 = publishable
    p1.publication.publish.save!
    p2 = publishable.new_version
    p2.save!
    p2.publication.publish.save!
    draft = publishable.new_version
    draft.save!

    expect(publishable.versions_visible_for(user)).to eq [p2.version, p1.version]
    expect(publishable.versions_visible_for(author)).to eq [draft.version, p2.version, p1.version]
  end
end
