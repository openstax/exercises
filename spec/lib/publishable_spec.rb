require 'rails_helper'

RSpec.describe Publishable, type: :lib do
  pending "add more examples to #{__FILE__}"

  subject(:publishable) { FactoryBot.create :exercise }

  let(:author) { FactoryBot.create :user }
  let(:coyright_holder) { FactoryBot.create :user }
  let(:user)   { FactoryBot.create :user }

  before { publishable.authors << Author.new(user: author)
           publishable.copyright_holders << CopyrightHolder.new(user: author) }

  it 'can determine versions visible for a user' do
    p1 = publishable
    p1.publication.publish.save!
    p2 = publishable.new_version
    p2.save!
    p2.publication.publish.save!
    draft = publishable.new_version
    draft.save!

    expect(publishable.visible_versions(can_view_solutions: false)).to(
      eq [p2.version, p1.version]
    )
    expect(publishable.visible_versions(can_view_solutions: true)).to(
      eq [draft.version, p2.version, p1.version]
    )
  end
end
