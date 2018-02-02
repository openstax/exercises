require 'rails_helper'

module Api::V1::Vocabs
  RSpec.describe TermRepresenter, type: :representer do

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

  end
end
