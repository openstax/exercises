require 'rails_helper'

module Api::V1
  RSpec.describe TermWithDistractorsRepresenter, type: :representer do

    let!(:term) {
      dbl = instance_spy(Term)
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
    let(:representation) { described_class.new(term).as_json }

    context 'name' do
      it 'can be read' do
        allow(term).to receive(:name).and_return('Question')
        expect(representation).to include('name' => 'Question')
      end

      it 'can be written' do
        described_class.new(term).from_json({'name' => 'Exercise'}.to_json)
        expect(term).to have_received(:name=).with('Exercise')
      end
    end

    context 'description' do
      it 'can be read' do
        allow(term).to receive(:description).and_return('This term is cool.')
        expect(representation).to include('description' => 'This term is cool.')
      end

      it 'can be written' do
        described_class.new(term)
                       .from_json({'description' => 'This term is cooler.'}.to_json)
        expect(term).to have_received(:description=).with('This term is cooler.')
      end
    end

    context 'distractor_terms' do
      it 'can be read' do
        term_1 = instance_spy(Term)
        allow(term_1).to receive(:name).and_return('Term 1')
        allow(term_1).to receive(:description).and_return('Description 1')
        term_2 = instance_spy(Term)
        allow(term_2).to receive(:name).and_return('Term 2')
        allow(term_2).to receive(:description).and_return('Description 2')
        term_3 = instance_spy(Term)
        allow(term_3).to receive(:name).and_return('Term 3')
        allow(term_3).to receive(:description).and_return('Description 3')

        distractor_terms = [term_1, term_2, term_3]

        term_representations = distractor_terms.map do |distractor_term|
          allow(distractor_term).to receive(:as_json).and_return(distractor_term)
          allow(distractor_term).to receive(:distractor_terms).and_return([])
          allow(distractor_term).to receive(:distractor_literals).and_return([])
          allow(distractor_term).to receive(:tags).and_return([])
          allow(distractor_term).to receive(:license).and_return(nil)
          allow(distractor_term).to receive(:editors).and_return([])
          allow(distractor_term).to receive(:authors).and_return([])
          allow(distractor_term).to receive(:copyright_holders).and_return([])
          allow(distractor_term).to receive(:derivations).and_return([])
          TermRepresenter.new(distractor_term).to_hash
        end

        allow(term).to receive(:distractor_terms).and_return(distractor_terms)

        expect(representation).to include('distractor_terms' => term_representations)
      end

      it 'can be written' do
        expect(term).to receive(:distractor_terms=)
                          .with(3.times.map{ a_kind_of(Term) }) do |terms|
          expect(terms.first.name).to  eq 'Term 1'
          expect(terms.first.description).to  eq 'Description 1'
          expect(terms.second.name).to eq 'Term 2'
          expect(terms.second.description).to  eq 'Description 2'
          expect(terms.third.name).to  eq 'Term 3'
          expect(terms.third.description).to  eq 'Description 3'
        end

        described_class.new(term).from_json({'distractor_terms' => [
          { 'name' => 'Term 1', 'description' => 'Description 1' },
          { 'name' => 'Term 2', 'description' => 'Description 2' },
          { 'name' => 'Term 3', 'description' => 'Description 3' }
        ]}.to_json)
      end
    end

    context 'distractor_literals' do
      it 'can be read' do
        literal_1 = 'Literal 1'
        literal_2 = 'Literal 2'
        literal_3 = 'Literal 3'

        distractor_literals = [literal_1, literal_2, literal_3]

        allow(term).to receive(:distractor_literals).and_return(distractor_literals)

        expect(representation).to include('distractor_literals' => distractor_literals)
      end

      it 'can be written' do
        expect(term).to receive(:distractor_literals=)
                          .with(3.times.map{ a_kind_of(String) }) do |literals|
          expect(literals.first).to  eq 'Literal 1'
          expect(literals.second).to eq 'Literal 2'
          expect(literals.third).to  eq 'Literal 3'
        end

        described_class.new(term).from_json({'distractor_literals' => [
          'Literal 1', 'Literal 2', 'Literal 3'
        ]}.to_json)
      end
    end

  end
end
