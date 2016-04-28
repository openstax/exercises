require 'rails_helper'

module Api::V1
  RSpec.describe VocabTermWithDistractorsAndExerciseIdsRepresenter, type: :representer do

    let!(:vocab_term) {
      dbl = instance_spy(VocabTerm)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:vocab_distractors).and_return([])
      allow(dbl).to receive(:distractor_literals).and_return([])
      allow(dbl).to receive(:exercise_ids).and_return([])
      allow(dbl).to receive(:tags).and_return([])
      allow(dbl).to receive(:license).and_return(nil)
      allow(dbl).to receive(:editors).and_return([])
      allow(dbl).to receive(:authors).and_return([])
      allow(dbl).to receive(:copyright_holders).and_return([])
      allow(dbl).to receive(:derivations).and_return([])
      dbl
    }

    # This is lazily-evaluated on purpose
    let(:representation) { described_class.new(vocab_term).as_json }

    context 'term' do
      it 'can be read' do
        allow(vocab_term).to receive(:name).and_return('Question')
        expect(representation).to include('term' => 'Question')
      end

      it 'can be written' do
        described_class.new(vocab_term).from_json({'term' => 'Exercise'}.to_json)
        expect(vocab_term).to have_received(:name=).with('Exercise')
      end
    end

    context 'definition' do
      it 'can be read' do
        allow(vocab_term).to receive(:definition).and_return('This term is cool.')
        expect(representation).to include('definition' => 'This term is cool.')
      end

      it 'can be written' do
        described_class.new(vocab_term)
                       .from_json({'definition' => 'This term is cooler.'}.to_json)
        expect(vocab_term).to have_received(:definition=).with('This term is cooler.')
      end
    end

    context 'distractor_terms' do
      it 'can be read' do
        vocab_distractor_1 = instance_spy(VocabDistractor)
        allow(vocab_distractor_1).to receive(:distractor_term_number).and_return(1)
        allow(vocab_distractor_1).to receive(:name).and_return('VocabTerm 1')
        allow(vocab_distractor_1).to receive(:definition).and_return('Definition 1')
        vocab_distractor_2 = instance_spy(VocabDistractor)
        allow(vocab_distractor_2).to receive(:distractor_term_number).and_return(2)
        allow(vocab_distractor_2).to receive(:name).and_return('VocabTerm 2')
        allow(vocab_distractor_2).to receive(:definition).and_return('Definition 2')
        vocab_distractor_3 = instance_spy(VocabDistractor)
        allow(vocab_distractor_3).to receive(:distractor_term_number).and_return(3)
        allow(vocab_distractor_3).to receive(:name).and_return('VocabTerm 3')
        allow(vocab_distractor_3).to receive(:definition).and_return('definition 3')

        vocab_distractors = [vocab_distractor_1, vocab_distractor_2, vocab_distractor_3]

        vocab_distractor_representations = vocab_distractors.map do |vocab_distractor|
          allow(vocab_distractor).to receive(:as_json).and_return(vocab_distractor)
          allow(vocab_distractor).to receive(:tags).and_return([])
          allow(vocab_distractor).to receive(:license).and_return(nil)
          allow(vocab_distractor).to receive(:editors).and_return([])
          allow(vocab_distractor).to receive(:authors).and_return([])
          allow(vocab_distractor).to receive(:copyright_holders).and_return([])
          allow(vocab_distractor).to receive(:derivations).and_return([])
          VocabDistractorRepresenter.new(vocab_distractor).to_hash
        end

        allow(vocab_term).to receive(:vocab_distractors).and_return(vocab_distractors)

        expect(representation).to include('distractor_terms' => vocab_distractor_representations)
      end

      it 'can be written' do
        vocab_distractors = 3.times.map{ FactoryGirl.create(:vocab_distractor) }
        expect(vocab_term).to(
          receive(:vocab_distractors=)
            .with(3.times.map{ a_kind_of(VocabDistractor) }) do |new_vocab_distractors|
            expect(Set.new new_vocab_distractors.map(&:distractor_term)).to eq(
              Set.new(vocab_distractors.map(&:distractor_term))
            )
          end
        )

        distractor_term_hash = vocab_distractors.map do |vocab_distractor|
          { 'number' => vocab_distractor.distractor_term_number }
        end
        described_class.new(vocab_term).from_json(
          {'distractor_terms' => distractor_term_hash}.to_json
        )
      end
    end

    context 'distractor_literals' do
      it 'can be read' do
        literal_1 = 'Literal 1'
        literal_2 = 'Literal 2'
        literal_3 = 'Literal 3'

        distractor_literals = [literal_1, literal_2, literal_3]

        allow(vocab_term).to receive(:distractor_literals).and_return(distractor_literals)

        expect(representation).to include('distractor_literals' => distractor_literals)
      end

      it 'can be written' do
        expect(vocab_term).to receive(:distractor_literals=)
                          .with(3.times.map{ a_kind_of(String) }) do |literals|
          expect(literals.first).to  eq 'Literal 1'
          expect(literals.second).to eq 'Literal 2'
          expect(literals.third).to  eq 'Literal 3'
        end

        described_class.new(vocab_term).from_json({'distractor_literals' => [
          'Literal 1', 'Literal 2', 'Literal 3'
        ]}.to_json)
      end
    end

    context 'exercise_ids' do
      it 'can be read' do
        exercise_ids = [42, 4, 2]

        allow(vocab_term).to receive(:exercise_ids).and_return(exercise_ids)

        expect(representation).to include('exercise_ids' => exercise_ids)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(vocab_term).not_to receive(:exercises=)
        expect(vocab_term).not_to receive(:exercise_ids=)

        described_class.new(vocab_term).from_json({'exercise_ids' => [42, 4, 2]}.to_json)
      end
    end

  end
end
