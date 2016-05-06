require 'rails_helper'

module Api::V1
  RSpec.describe VocabDistractorRepresenter, type: :representer do

    let!(:distractor_term) {
      instance_spy(VocabTerm).tap do |dbl|
        allow(dbl).to receive(:as_json).and_return(dbl)
      end
    }

    let!(:vocab_distractor) {
      instance_spy(VocabDistractor).tap do |dbl|
        allow(dbl).to receive(:as_json).and_return(dbl)
        allow(dbl).to receive(:tags).and_return([])
        allow(dbl).to receive(:license).and_return(nil)
        allow(dbl).to receive(:editors).and_return([])
        allow(dbl).to receive(:authors).and_return([])
        allow(dbl).to receive(:copyright_holders).and_return([])
        allow(dbl).to receive(:derivations).and_return([])
        allow(dbl).to receive(:distractor_term).and_return(distractor_term)
      end
    }

    # This is lazily-evaluated on purpose
    let(:representation) { described_class.new(vocab_distractor).as_json }

    context 'number' do
      it 'can be read' do
        allow(vocab_distractor).to receive(:distractor_term_number).and_return(42)
        expect(representation).to include('number' => 42)
      end

      it 'can be written' do
        described_class.new(vocab_distractor).from_json({'number' => 84}.to_json)
        expect(vocab_distractor).to have_received(:distractor_term_number=).with(84)
      end
    end

    context 'term' do
      it 'can be read' do
        allow(vocab_distractor).to receive(:name).and_return('Question')
        expect(representation).to include('term' => 'Question')
      end

      it 'cannot be written (attempts are silently ignored)' do
        described_class.new(vocab_distractor).from_json({'term' => 'Exercise'}.to_json)
        expect(distractor_term).not_to have_received(:name=)
      end
    end

    context 'definition' do
      it 'can be read' do
        allow(vocab_distractor).to receive(:definition).and_return('This term is cool.')
        expect(representation).to include('definition' => 'This term is cool.')
      end

      it 'cannot be written (attempts are silently ignored)' do
        described_class.new(vocab_distractor)
                       .from_json({'definition' => 'This term is cooler.'}.to_json)
        expect(distractor_term).not_to have_received(:definition=)
      end
    end

  end
end
