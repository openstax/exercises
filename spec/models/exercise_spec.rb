require 'rails_helper'

RSpec.describe Exercise, type: :model do

  subject(:exercise) { FactoryBot.create :exercise }

  it { is_expected.to have_many(:questions).dependent(:destroy).autosave(true) }

  it { is_expected.to have_many(:exercise_tags).dependent(:destroy) }

  it 'can check for the presence of questions' do
    exercise = FactoryBot.create :exercise
    exercise.send :has_questions
    expect(exercise.errors).to be_empty

    exercise.questions = []
    expect { exercise.send :has_questions }.to throw_symbol(:abort)
    expect(exercise.errors[:questions]).to include("can't be blank")
  end

  it 'ensures that no questions have all incorrect answers before publication' do
    exercise = FactoryBot.create :exercise
    exercise.before_publication
    expect(exercise.errors).to be_empty

    exercise.questions.first.stems.first.stem_answers.each do |stem_answer|
      stem_answer.update_attribute :correctness, 0.0
    end
    expect { exercise.before_publication }.to throw_symbol(:abort)
    expect(exercise.errors[:base]).to include('has a question with only incorrect answers')
  end

  context 'can_view_solutions?' do
    let(:anonymous)        { AnonymousUser.instance                     }

    let(:user)             { FactoryBot.create :user                   }
    let(:author)           { FactoryBot.create :user                   }
    let(:copyright_holder) { FactoryBot.create :user                   }

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
