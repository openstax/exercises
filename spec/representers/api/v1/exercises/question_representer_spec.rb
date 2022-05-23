require 'rails_helper'

module Api::V1::Exercises
  RSpec.describe QuestionRepresenter, type: :representer do

    let(:exercise) { FactoryBot.create :exercise }
    let(:question) { exercise.questions.first }

    # This is lazily-evaluated on purpose
    let(:representation) do
      described_class.new(question).to_hash(user_options: { can_view_solutions: true })
    end

    context 'id' do
      it 'can be read' do
        expect(representation).to include('id' => question.id)
      end

      it 'can be written (sets the temp_id attribute)' do
        expect(question).to_not receive(:id=)
        expect(question).to receive(:temp_id=).with(42)
        described_class.new(question).from_hash('id' => 42)
      end
    end

    context 'answer_order_matters' do
      it 'can be read' do
        expect(representation).to(
          include('is_answer_order_important' => question.answer_order_matters)
        )
      end

      it 'can be written' do
        expect(question).to receive(:answer_order_matters=).with(false)
        described_class.new(question).from_hash('is_answer_order_important' => false)
      end
    end

    context 'stimulus' do
      it 'can be read' do
        expect(representation).to include('stimulus_html' => question.stimulus)
      end

      it 'can be written' do
        expect(question).to receive(:stimulus=).with('This question is cool.')
        described_class.new(question).from_hash('stimulus_html' => 'This question is cool.')
      end
    end

    context 'stems' do
      it 'can be read' do
        stem_representations = question.stems.map { |stem| StemRepresenter.new(stem).to_hash(user_options: { can_view_solutions: true }) }
        expect(representation).to include('stems' => stem_representations)
      end

      it 'can be written' do
        stems = [ Stem.new(content: "Don't you agree?") ]
        expect(question.stems).to receive(:replace).with([kind_of(Stem)]) do |stems|
          expect(stems.first.content).to eq "Don't you agree?"
        end

        described_class.new(question).from_hash(
          'stems' => [ { 'content_html' => "Don't you agree?" } ]
        )
      end
    end

    context 'answers' do
      it 'can be read' do
        3.times { question.answers << FactoryBot.build(:answer, question: question) }

        answer_representations = question.answers.map do |answer|
          AnswerRepresenter.new(answer).to_hash(user_options: { can_view_solutions: true })
        end

        expect(representation).to include('answers' => answer_representations)
      end

      it 'can be written' do
        expect(question.answers).to receive(:replace).with([kind_of(Answer)]*3) do |answers|
          expect(answers.map(&:content)).to eq [ 'Yes', 'No', 'Maybe so' ]
        end

        described_class.new(question).from_hash(
          'answers' => [
            { 'content_html' => 'Yes' },
            { 'content_html' => 'No' },
            { 'content_html' => 'Maybe so' }
          ]
        )
      end
    end

    context 'collaborator_solutions' do
      it 'can be read' do
        solution_representations = question.collaborator_solutions.map do |sol|
          CollaboratorSolutionRepresenter.new(sol)
                                         .to_hash(user_options: { can_view_solutions: true })
        end
        expect(representation).to include('collaborator_solutions' => solution_representations)
      end

      it 'can be written' do
        expect(question.collaborator_solutions).to(
          receive(:replace).with([kind_of(CollaboratorSolution)]) do |collaborator_solutions|
            expect(collaborator_solutions.first.title).to eq 'Test'
            expect(collaborator_solutions.first.solution_type).to eq 'example'
            expect(collaborator_solutions.first.content).to eq 'This is a test.'
          end
        )

        described_class.new(question).from_hash(
          {
            'collaborator_solutions' => [
              {
                'title' => 'Test',
                'solution_type' => 'example',
                'content_html' => 'This is a test.'
              }
            ]
          }
        )
      end
    end

    context 'community_solutions' do
      it 'can be read' do
        solution_representations = question.community_solutions.map do |sol|
          CommunitySolutionRepresenter.new(sol).to_hash(user_options: { can_view_solutions: true })
        end
        expect(representation).to include('community_solutions' => solution_representations)
      end

      it 'cannot be written (attempts are silently ignored)' do
        expect(question.community_solutions).not_to receive(:replace)

        described_class.new(question).from_hash(
          {
            'community_solutions' => [
              {
                'title' => 'Test',
                'solution_type' => 'example',
                'content_html' => 'This is a test.'
              }
            ]
          }
        )
      end
    end

    context 'hints' do
      it 'can be read' do
        hint_representations = question.hints.map(&:content)
        expect(representation).to include('hints' => hint_representations)
      end

      it 'can be written' do
        expect(question.hints).to receive(:replace).with([kind_of(Hint)]) do |hints|
          expect(hints.first.content).to eq 'A hint'
        end

        described_class.new(question).from_hash('hints' => [ 'A hint' ])
      end
    end

    context 'parent_dependencies' do
      it 'can be read' do
        expect(representation).to include('dependencies' => question.parent_dependencies)
      end

      it 'can be written' do
        expect(question.parent_dependencies).to(
          receive(:replace).with([kind_of(QuestionDependency)]) do |question_dependencies|
            expect(question_dependencies.first.dependent_question).to eq question
            expect(question_dependencies.first.parent_question).to eq question
            expect(question_dependencies.first.is_optional).to eq true
          end
        )

        described_class.new(question).from_hash(
          'dependencies' => [ 'parent_question_id' => question.id, 'is_optional' => true ]
        )
      end
    end

  end
end
