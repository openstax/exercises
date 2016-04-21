require 'rails_helper'

module Api::V1
  RSpec.describe VocabTermWithDistractorsRepresenter, type: :representer do

    let!(:vocab_term) {
      dbl = instance_spy(VocabTerm)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:distractor_terms).and_return([])
      allow(dbl).to receive(:distractor_literals).and_return([])
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

    context 'name' do
      it 'can be read' do
        allow(vocab_term).to receive(:name).and_return('Question')
        expect(representation).to include('name' => 'Question')
      end

      it 'can be written' do
        described_class.new(vocab_term).from_json({'name' => 'Exercise'}.to_json)
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
        vocab_term_1 = instance_spy(VocabTerm)
        allow(vocab_term_1).to receive(:name).and_return('VocabTerm 1')
        allow(vocab_term_1).to receive(:definition).and_return('Definition 1')
        vocab_term_2 = instance_spy(VocabTerm)
        allow(vocab_term_2).to receive(:name).and_return('VocabTerm 2')
        allow(vocab_term_2).to receive(:definition).and_return('Definition 2')
        vocab_term_3 = instance_spy(VocabTerm)
        allow(vocab_term_3).to receive(:name).and_return('VocabTerm 3')
        allow(vocab_term_3).to receive(:definition).and_return('definition 3')

        distractor_terms = [vocab_term_1, vocab_term_2, vocab_term_3]

        vocab_term_representations = distractor_terms.map do |distractor_term|
          allow(distractor_term).to receive(:as_json).and_return(distractor_term)
          allow(distractor_term).to receive(:distractor_terms).and_return([])
          allow(distractor_term).to receive(:distractor_literals).and_return([])
          allow(distractor_term).to receive(:tags).and_return([])
          allow(distractor_term).to receive(:license).and_return(nil)
          allow(distractor_term).to receive(:editors).and_return([])
          allow(distractor_term).to receive(:authors).and_return([])
          allow(distractor_term).to receive(:copyright_holders).and_return([])
          allow(distractor_term).to receive(:derivations).and_return([])
          VocabTermRepresenter.new(distractor_term).to_hash
        end

        allow(vocab_term).to receive(:distractor_terms).and_return(distractor_terms)

        expect(representation).to include('distractor_terms' => vocab_term_representations)
      end

      it 'can be written' do
        expect(vocab_term).to receive(:distractor_terms=)
                          .with(3.times.map{ a_kind_of(VocabTerm) }) do |vocab_terms|
          expect(vocab_terms.first.name).to  eq 'VocabTerm 1'
          expect(vocab_terms.first.definition).to  eq 'Definition 1'
          expect(vocab_terms.second.name).to eq 'VocabTerm 2'
          expect(vocab_terms.second.definition).to  eq 'Definition 2'
          expect(vocab_terms.third.name).to  eq 'VocabTerm 3'
          expect(vocab_terms.third.definition).to  eq 'Definition 3'
        end

        described_class.new(vocab_term).from_json({'distractor_terms' => [
          { 'name' => 'VocabTerm 1', 'definition' => 'Definition 1' },
          { 'name' => 'VocabTerm 2', 'definition' => 'Definition 2' },
          { 'name' => 'VocabTerm 3', 'definition' => 'Definition 3' }
        ]}.to_json)
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

  end
end
