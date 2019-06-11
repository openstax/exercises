require 'rails_helper'

RSpec.describe VocabTerm, type: :model do
  subject(:vocab_term) { FactoryBot.create :vocab_term }

  it { is_expected.to have_many(:vocab_distractors) }

  it { is_expected.to have_many(:exercises).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }

  it 'saves even if the definition is blank' do
    vocab_term.definition = ''
    vocab_term.save!

    vt = VocabTerm.new(name: 'test')
    vt.save!
    expect(vt.definition).to eq ''
  end

  it 'ensures that it has a definition before publication' do
    vocab_term.publication.publish
    vocab_term.before_publication
    expect(vocab_term.errors).to be_empty

    vocab_term.definition = ''
    expect { vocab_term.before_publication }.to throw_symbol(:abort)
    expect(vocab_term.errors[:base]).to include('must have a definition')
  end

  it 'ensures that it has at least 1 distractor before publication' do
    vocab_term.publication.publish
    vocab_term.before_publication
    expect(vocab_term.errors).to be_empty

    vocab_term.vocab_distractors.destroy_all
    vocab_term.distractor_literals = ['Distractor']
    vocab_term.before_publication
    expect(vocab_term.errors).to be_empty

    vocab_term.distractor_literals = []
    expect { vocab_term.before_publication }.to throw_symbol(:abort)
    expect(vocab_term.errors[:base]).to include('must have at least 1 distractor')
  end

  it 'automatically creates vocab exercises on save' do
    expect(vocab_term.exercises).not_to be_empty
    vocab_term.exercises.each do |exercise|
      expect(Set.new exercise.tags).to eq Set.new(vocab_term.tags)

      question = exercise.questions.first
      stem = question.stems.first
      expect(stem.content).to eq "Define <strong>#{vocab_term.name}</strong> in your own words."
      expect(Set.new stem.stylings.map(&:style)).to(
        eq Set[Style::MULTIPLE_CHOICE, Style::FREE_RESPONSE]
      )
      expect(question.answers).not_to be_empty
      expect(Set.new question.answers.map(&:content)).to eq Set.new vocab_term.distractors
      stem.stem_answers.each do |stem_answer|
        correctness = stem_answer.answer.content == vocab_term.definition ? 1.0 : 0.0
        expect(stem_answer.correctness).to eq correctness
      end
    end
  end

  it 'automatically publishes vocab exercises when published' do
    expect(vocab_term.exercises).not_to be_empty
    vocab_term.exercises.each { |exercise| expect(exercise).not_to be_is_published }
    vocab_term.publication.publish.save!
    vocab_term.exercises.each { |exercise| expect(exercise).to be_is_published }
  end

  it 'does not create extra versions of exercises when creating a new version' do
    vocab_term.exercises.first.publication.publish.save!
    vocab_term.exercises << vocab_term.exercises.first.new_version
    expect(vocab_term.exercises.size).to eq 2
    vocab_term.publication.publish.save!
    vocab_term.exercises.each { |exercise| expect(exercise).to be_is_published }
    new_version = vocab_term.new_version
    expect(new_version.exercises.size).to eq 1
  end

  it 'updates distracted_term exercises when published' do
    distractor_term = vocab_term.vocab_distractors.first.distractor_term
    distractor_term.distractor_literals = ['Required for publication']
    distractor_term.definition = 'Something'
    distractor_term.save!

    vocab_term.exercises.reload
    exercises = vocab_term.exercises.to_a
    expect(exercises).to eq vocab_term.latest_exercises
    expect(exercises.size).to eq 1

    expect{
      # A published distractor term updates the vocab term's exercises
      distractor_term.publication.publish.save!
    }.to change{
      @answers = exercises.map(&:reload).flat_map(&:questions).flat_map(&:answers).map(&:content)
    }

    vocab_term.exercises.reload
    expect(exercises).to eq vocab_term.exercises
    expect(exercises).to eq vocab_term.latest_exercises

    expect(@answers).to include('Something')

    # Vocab term exercises are now published and can no longer be updated
    vocab_term.publication.publish.save!
    expect{
      distractor_term = distractor_term.new_version
      distractor_term.save!
    }.not_to change{ vocab_term.reload.distractor_terms.size }
    distractor_term.update_attribute :definition, 'Something else'

    expect{
      # The published distractor term will now create new versions of the exercises
      distractor_term.publication.publish.save!
    }.not_to change{
      @old_answers = \
        exercises.map(&:reload).flat_map(&:questions).flat_map(&:answers).map(&:content)
    }

    vocab_term.exercises.reload
    expect(vocab_term.latest_exercises).not_to eq exercises
    expect(exercises.size).to eq 1
    expect(vocab_term.exercises.size).to eq 2
    expect(vocab_term.latest_exercises.size).to eq 1

    expect(@old_answers).to include('Something')
    expect(@old_answers).not_to include('Something else')

    latest_answers = \
      vocab_term.reload.latest_exercises.flat_map(&:questions).flat_map(&:answers).map(&:content)
    expect(latest_answers).not_to include('Something')
    expect(latest_answers).to include('Something else')

    all_answers = vocab_term.exercises.flat_map(&:questions).flat_map(&:answers).map(&:content)
    expect(all_answers).to include('Something')
    expect(all_answers).to include('Something else')
  end

  it 'can unlink itself from other vocab terms' do
    expect(vocab_term.vocab_distractors).not_to be_empty
    old_distractors = vocab_term.distractors

    vocab_term.unlink

    expect(vocab_term).to be_valid
    expect(vocab_term.vocab_distractors).to be_empty
    expect(vocab_term.distractors).to match_array(old_distractors)
  end
end
