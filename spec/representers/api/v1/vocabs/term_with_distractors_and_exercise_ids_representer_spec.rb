require 'rails_helper'

module Api::V1::Vocabs
  RSpec.describe TermWithDistractorsAndExerciseIdsRepresenter, type: :representer do

    let(:vocab_term) { FactoryBot.create :vocab_term }

    # This is lazily-evaluated on purpose
    let(:representation) do
      described_class.new(vocab_term).to_hash(user_options: { can_view_solutions: true })
    end

    context 'term' do
      it 'can be read' do
        expect(representation).to include('term' => vocab_term.name)
      end

      it 'can be written' do
        expect(vocab_term).to receive(:name=).with('Exercise')
        described_class.new(vocab_term).from_hash('term' => 'Exercise')
      end
    end

    context 'definition' do
      it 'can be read' do
        expect(representation).to include('definition' => vocab_term.definition)
      end

      it 'can be written' do
        expect(vocab_term).to receive(:definition=).with('This term is cool.')
        described_class.new(vocab_term).from_hash('definition' => 'This term is cool.')
      end
    end

    context 'distractor_terms' do
      it 'can be read' do
        3.times do
          vocab_term.vocab_distractors << FactoryBot.build(
            :vocab_distractor, vocab_term: vocab_term
          )
        end

        vocab_distractor_representations = vocab_term.vocab_distractors.map do |vocab_distractor|
          DistractorRepresenter.new(vocab_distractor)
                               .to_hash(user_options: { can_view_solutions: true })
        end

        expect(representation).to include('distractor_terms' => vocab_distractor_representations)
      end

      it 'can be written' do
        vocab_distractors = 3.times.map { FactoryBot.create :vocab_distractor }
        distractor_term_hash = vocab_distractors.map do |vocab_distractor|
          { 'group_uuid' => vocab_distractor.distractor_publication_group.uuid }
        end

        expect(vocab_term.vocab_distractors).to(
          receive(:replace).with([kind_of(VocabDistractor)]*3) do |vds|
            expect(vds.map(&:distractor_term)).to eq vocab_distractors.map(&:distractor_term)
          end
        )

        described_class.new(vocab_term).from_hash('distractor_terms' => distractor_term_hash)
      end
    end

    context 'distractor_literals' do
      it 'can be read' do
        expect(representation).to include('distractor_literals' => vocab_term.distractor_literals)
      end

      it 'can be written' do
        expect(vocab_term).to(
          receive(:distractor_literals=).with([ kind_of(String) ] * 3).once do |literals|
            expect(literals).to eq [ 'Literal 1', 'Literal 2', 'Literal 3' ]
          end
        )

        described_class.new(vocab_term).from_hash(
          'distractor_literals' => [ 'Literal 1', 'Literal 2', 'Literal 3' ]
        )
      end
    end

    context 'exercise_uuids' do
      it 'can be read' do
        expect(representation).to(
          include('exercise_uuids' => vocab_term.latest_exercises.map(&:uuid))
        )
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(vocab_term.exercises).not_to receive(:replace)
        expect(vocab_term.exercise_ids).not_to receive(:replace)

        described_class.new(vocab_term).from_hash('exercise_uuids' => [ SecureRandom.uuid ])
      end
    end

    context 'exercise_uids' do
      it 'can be read' do
        expect(representation).to include('exercise_uids' => vocab_term.latest_exercises.map(&:uid))
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(vocab_term.exercises).not_to receive(:replace)
        expect(vocab_term.exercise_ids).not_to receive(:replace)

        described_class.new(vocab_term).from_hash('exercise_uids' => ['42@1', '4@2'])
      end
    end

  end
end
