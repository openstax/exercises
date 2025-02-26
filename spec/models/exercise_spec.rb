require 'vcr_helper'

RSpec.describe Exercise, type: :model, vcr: VCR_OPTS do
  subject(:exercise) { FactoryBot.create :exercise }

  it { is_expected.to have_many(:questions).dependent(:destroy).autosave(true) }

  it { is_expected.to have_many(:exercise_tags).dependent(:destroy) }

  it 'automatically sets the context based on tags and rewrites image links' do
    # Disable set_slug_tags!
    expect_any_instance_of(Exercise).to receive(:set_slug_tags!).twice

    exercise.tags = [
      'context-cnxmod:4ee317f2-cc23-4075-b377-51ee4d11bb61',
      'context-cnxfeature:fs-id2371798'
    ]
    exercise.save!

    expect(exercise.context).to include(
      '<img src="https://openstax.org/apps/archive/20210514.171726/resources/af928eb129c65a18bffdc32353f1ffeeaf081157"'
    )
  end

  it 'automatically sets slug tags' do
    expect(Content).to receive(:slugs_by_page_uuid).and_return({'4ee317f2-cc23-4075-b377-51ee4d11bb61' => [
      {:book=>"introduction-sociology-2e", :page=>"3-3-pop-culture-subculture-and-cultural-change"}
    ]})
    exercise.tags = [ 'context-cnxmod:4ee317f2-cc23-4075-b377-51ee4d11bb61' ]
    exercise.save!

    expect(exercise.tags.map(&:name)).to eq(
      [
        'context-cnxmod:4ee317f2-cc23-4075-b377-51ee4d11bb61',
        'book-slug:introduction-sociology-2e',
        'module-slug:introduction-sociology-2e:3-3-pop-culture-subculture-and-cultural-change'
      ]
    )
  end

  it 'can check for the presence of questions' do
    exercise.send :has_questions
    expect(exercise.errors).to be_empty

    exercise.questions = []
    expect { exercise.send :has_questions }.to throw_symbol(:abort)
    expect(exercise.errors[:questions]).to include "can't be blank"
  end

  it 'ensures that no questions have all incorrect answers before publication' do
    exercise.before_publication
    expect(exercise.errors).to be_empty

    exercise.questions.first.stems.first.stem_answers.each do |stem_answer|
      stem_answer.update_attribute :correctness, 0.0
    end
    expect { exercise.before_publication }.to throw_symbol(:abort)
    expect(exercise.errors[:base]).to include 'has a question with only incorrect answers'
  end

  context 'can_view_solutions?' do
    let(:anonymous)         { AnonymousUser.instance                     }

    let(:user)              { FactoryBot.create :user                   }
    let(:author)            { FactoryBot.create :user                   }
    let(:copyright_holder)  { FactoryBot.create :user                   }

    let(:application_token) { FactoryBot.create :doorkeeper_access_token, resource_owner_id: nil }
    let(:application_user)  { OpenStax::Api::ApiUser.new(application_token, ->(*) { nil }) }

    before do
      exercise.publication.authors << Author.new(user: author)
      exercise.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder)
    end

    it 'is true for collaborators and their delegates' do
      expect(exercise.can_view_solutions?(author)).to eq true
      expect(exercise.can_view_solutions?(copyright_holder)).to eq true

      delegation = FactoryBot.create :delegation, delegator: author, delegate: user, can_read: false
      expect(exercise.can_view_solutions?(user)).to eq false

      delegation.update_attribute :can_read, true
      expect(exercise.can_view_solutions?(user)).to eq true

      delegation.update_attribute :delegator, copyright_holder
      expect(exercise.can_view_solutions?(user)).to eq true

      delegation.update_attribute :can_read, false
      expect(exercise.can_view_solutions?(user)).to eq false

      delegation.destroy
      expect(exercise.can_view_solutions?(user)).to eq false
    end

    it 'is true for external applications' do
      expect(exercise.can_view_solutions?(application_user)).to eq true
    end

    it 'is false for anyone else' do
      expect(exercise.can_view_solutions?(anonymous)).to eq false
      expect(exercise.can_view_solutions?(user)).to eq false
    end
  end
end
