require 'rails_helper'

RSpec.describe VocabTerm, type: :model do
  subject(:vocab_term) { FactoryGirl.create :vocab_term }

  it { is_expected.to have_many(:vocab_distractors) }
  it { is_expected.to have_many(:distractor_terms).through(:vocab_distractors) }

  it { is_expected.to have_many(:exercises).dependent(:destroy) }

  it { is_expected.to have_many(:list_vocab_terms).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:definition) }

  it 'ensures that it has at least 1 distractor before publication' do
    vocab_term.publication.publish
    vocab_term.before_publication
    expect(vocab_term.errors).to be_empty

    vocab_term.vocab_distractors.destroy_all
    vocab_term.distractor_literals = ['Distractor']
    vocab_term.before_publication
    expect(vocab_term.errors).to be_empty

    vocab_term.distractor_literals = []
    vocab_term.before_publication
    expect(vocab_term.errors[:base]).to include('must have at least 1 distractor')
  end

  it 'automatically creates vocab exercises on save' do
    expect(vocab_term.exercises).not_to be_empty
    vocab_term.exercises.each do |exercise|
      question = exercise.questions.first
      stem = question.stems.first
      expect(stem.content).to eq "#{vocab_term.name}?"
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
    vocab_term.exercises.each{ |exercise| expect(exercise).not_to be_is_published }
    vocab_term.publication.publish.save!
    vocab_term.exercises.each{ |exercise| expect(exercise).to be_is_published }
  end
end
