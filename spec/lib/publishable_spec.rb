require 'rails_helper'

RSpec.describe Publishable, type: :lib do
  subject(:publishable)    { FactoryBot.create :exercise }

  let(:author)             { FactoryBot.create :user }
  let(:copyright_holder)   { FactoryBot.create :user }
  let(:user)               { FactoryBot.create :user }
  let(:admin)              { FactoryBot.create :user, :administrator }
  let(:author_delegate)    do
    FactoryBot.create(:delegation, delegator: author, can_read: true).delegate
  end
  let(:copyright_delegate) do
    FactoryBot.create(:delegation, delegator: copyright_holder, can_read: true).delegate
  end

  before do
    publishable.authors << Author.new(user: author)
    publishable.copyright_holders << CopyrightHolder.new(user: copyright_holder)
  end

  context 'with a new version available' do
    before             { publishable.publication.publish.save! }
    let!(:new_version) { publishable.new_version.tap(&:save!) }

    it 'can return publishables by id' do
      expect(publishable.class.with_id(publishable.number)).to eq [ publishable ]
      expect(publishable.class.with_id(publishable.publication_group.uuid)).to eq [ publishable ]
      expect(publishable.class.with_id(publishable.uuid)).to eq [ publishable ]
      expect(publishable.class.with_id(publishable.uid)).to eq [ publishable ]
      expect(publishable.class.with_id("#{publishable.number}@draft")).to eq [ new_version ]
      expect(publishable.class.with_id("#{publishable.number}@d")).to eq [ new_version ]
      expect(publishable.class.with_id("#{publishable.number}@latest")).to(
        eq [ new_version, publishable ]
      )
    end

    it 'can determine versions visible for a user' do
      expect(publishable.class.visible_for(user: nil)).to eq [ publishable ]
      expect(publishable.class.visible_for(user: user)).to eq [ publishable ]
      expect(publishable.class.visible_for(user: admin)).to match_array [ publishable, new_version ]
      expect(publishable.class.visible_for(user: author)).to(
        match_array [ publishable, new_version ]
      )
      expect(publishable.class.visible_for(user: copyright_holder)).to(
        match_array [ publishable, new_version ]
      )
      expect(publishable.class.visible_for(user: author_delegate)).to(
        match_array [ publishable, new_version ]
      )
      expect(publishable.class.visible_for(user: copyright_delegate)).to(
        match_array [ publishable, new_version ]
      )
    end
  end
end
