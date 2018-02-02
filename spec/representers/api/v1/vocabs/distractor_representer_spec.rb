require 'rails_helper'

module Api::V1::Vocabs
  RSpec.describe DistractorRepresenter, type: :representer do

    let(:vocab_distractor) { FactoryBot.create :vocab_distractor }
    let(:distractor_term)  { vocab_distractor.distractor_term }

    # This is lazily-evaluated on purpose
    let(:representation) do
      described_class.new(vocab_distractor).to_hash(user_options: { can_view_solutions: true })
    end

    context 'group_uuid' do
      it 'can be read' do
        expect(representation).to include('group_uuid' => vocab_distractor.group_uuid)
      end

      it 'can be written' do
        uuid = SecureRandom.uuid
        expect(vocab_distractor).to receive(:group_uuid=).with(uuid)
        described_class.new(vocab_distractor).from_hash('group_uuid' => uuid)
      end
    end

    context 'number' do
      it 'can be read' do
        expect(representation).to include('number' => vocab_distractor.number)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(vocab_distractor).not_to receive(:number=)
        described_class.new(vocab_distractor).from_hash('number' => 42)
      end
    end

    context 'term' do
      it 'can be read' do
        expect(representation).to include('term' => vocab_distractor.name)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(distractor_term).not_to receive(:name=)
        described_class.new(vocab_distractor).from_hash('term' => 'Exercise')
      end
    end

    context 'definition' do
      it 'can be read' do
        expect(representation).to include('definition' => vocab_distractor.definition)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(distractor_term).not_to receive(:definition=)
        described_class.new(vocab_distractor).from_hash('definition' => 'This term is cool.')
      end
    end

  end
end
