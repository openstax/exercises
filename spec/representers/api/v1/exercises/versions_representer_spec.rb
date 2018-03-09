require 'rails_helper'

module Api::V1::Exercises
  RSpec.describe VersionsRepresenter, type: :representer do

    let(:vocab_term) { FactoryBot.create :vocab_term }
    let(:exercise)   { vocab_term.exercises.first }

    # This is lazily-evaluated on purpose
    let(:representation) do
      described_class.new(exercise).to_hash(
        user_options: { can_view_solutions: can_view_solutions }
      )
    end

    [ true, false ].each do |can_view_solutions|
      context "can_view_solutions: #{can_view_solutions}" do
        let(:can_view_solutions) { can_view_solutions }

        context 'versions' do
          it 'can be read' do
            expect(representation).to include(
              'versions' => exercise.visible_versions(can_view_solutions: can_view_solutions)
            )
          end

          it 'cannot be written (attempts are silently ignored)' do
            expect do
              described_class.new(exercise).from_hash('versions' => [1, 2, 3])
            end.not_to change { exercise.reload }
          end
        end
      end
    end

    context "can_view_solutions? queries" do
      let!(:real_exercise) { FactoryBot.create(:exercise, questions_count: 1)}
      let!(:user) { FactoryBot.create :user }

      it 'only calls can_view_solutions? one time' do
        expect_any_instance_of(Exercise).to receive(:can_view_solutions?).once.and_call_original
        described_class.new(real_exercise).as_json
      end
    end

  end
end
