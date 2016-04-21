require 'rails_helper'

module Api::V1
  RSpec.describe TermRepresenter, type: :representer do

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

  end
end
