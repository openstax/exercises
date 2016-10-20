require 'rails_helper'

module Api::V1
  RSpec.describe QuestionRepresenter, type: :representer do

    let(:exercise) {
      dbl = instance_spy(Exercise)
      allow(dbl).to receive(:as_json).and_return(dbl)
      dbl
    }

    let(:question) {
      dbl = instance_spy(Question)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:stems).and_return([])
      allow(dbl).to receive(:answers).and_return([])
      allow(dbl).to receive(:collaborator_solutions).and_return([])
      allow(dbl).to receive(:community_solutions).and_return([])
      allow(dbl).to receive(:hints).and_return([])
      allow(dbl).to receive(:parent_dependencies).and_return([])
      dbl
    }

    before(:each) do
      allow(exercise).to receive(:questions).and_return([question])
      allow(question).to receive(:exercise).and_return(exercise)
    end

    # This is lazily-evaluated on purpose
    let(:representation) {
      described_class.new(question).as_json
    }

    context 'id' do
      it 'can be read' do
        allow(question).to receive(:id).and_return(21)
        expect(representation).to include('id' => 21)
      end

      it 'can be written (sets the temp_id attribute)' do
        described_class.new(question).from_json({'id' => 42}.to_json)
        expect(question).to_not have_received(:id=)
        expect(question).to have_received(:temp_id=).with(42)
      end
    end

    context 'answer_order_matters' do
      it 'can be read' do
        allow(question).to receive(:answer_order_matters).and_return(false)
        expect(representation).to include('is_answer_order_important' => false)
      end

      it 'can be written' do
        described_class.new(question).from_json({'is_answer_order_important' => false}.to_json)
        expect(question).to have_received(:answer_order_matters=).with(false)
      end
    end

    context 'stimulus' do
      it 'can be read' do
        allow(question).to receive(:stimulus).and_return('This question is cool.')
        expect(representation).to include('stimulus_html' => 'This question is cool.')
      end

      it 'can be written' do
        described_class.new(question)
                       .from_json({'stimulus_html' => 'This question is cooler.'}.to_json)
        expect(question).to have_received(:stimulus=).with('This question is cooler.')
      end
    end

    context 'stems' do
      it 'can be read' do
        stems = [Stem.new(content: 'Don\'t you agree?')]
        stem_representations = stems.collect{ |stem| StemRepresenter.new(stem).to_hash }
        allow(question).to receive(:stems).and_return(stems)
        expect(representation).to include('stems' => stem_representations)
      end

      it 'can be written' do
        stems = [Stem.new(content: 'Yes, I do!')]
        stem_representations = stems.collect{ |stem| StemRepresenter.new(stem).to_hash }
        described_class.new(question).from_json({ 'stems' => stem_representations }.to_json)
        expect(question).to have_received(:stems=).with([ a_kind_of(Stem) ]) do |stems|
          expect(stems.first.content).to eq 'Yes, I do!'
        end
      end
    end

    context 'answers' do
      it 'can be read' do
        answer_1 = instance_spy(Answer)
        allow(answer_1).to receive(:id).and_return(1)
        allow(answer_1).to receive(:sort_position).and_return(2)
        allow(answer_1).to receive(:content).and_return('No')
        answer_2 = instance_spy(Answer)
        allow(answer_2).to receive(:id).and_return(2)
        allow(answer_2).to receive(:sort_position).and_return(1)
        allow(answer_2).to receive(:content).and_return('Yes')
        answer_3 = instance_spy(Answer)
        allow(answer_3).to receive(:id).and_return(3)
        allow(answer_3).to receive(:sort_position).and_return(3)
        allow(answer_3).to receive(:content).and_return('Maybe so')

        sorted_answers = [answer_2, answer_1, answer_3]

        answer_representations = sorted_answers.map do |answer|
          allow(answer).to receive(:as_json).and_return(answer)
          allow(answer).to receive(:question).and_return(question)
          allow(answer).to receive(:stem_answers).and_return([])
          AnswerRepresenter.new(answer).to_hash
        end

        allow(question).to receive(:answers).and_return(sorted_answers)

        expect(representation).to include('answers' => answer_representations)
      end

      it 'can be written' do
        # instance_spy doesn't work here because the Answers being created expect a real Question
        real_q = FactoryGirl.build :question

        expect(real_q).to receive(:answers=).with(3.times.map{ a_kind_of(Answer) }) do |answers|
          expect(answers.first.content).to eq 'Yes'
          expect(answers.second.content).to eq 'No'
          expect(answers.third.content).to eq 'Maybe so'
        end

        described_class.new(real_q).from_json({'answers' => [
          { 'content_html' => 'Yes' }, { 'content_html' => 'No' }, { 'content_html' => 'Maybe so' }
        ]}.to_json)
      end
    end

    context 'collaborator_solutions' do
      it 'can be read' do
        solutions = [CollaboratorSolution.new(content: 'Of course.')]
        solution_representations = solutions.collect do |sol|
          CollaboratorSolutionRepresenter.new(sol).to_hash
        end
        allow(question).to receive(:collaborator_solutions).and_return(solutions)
        expect(representation).to include('collaborator_solutions' => solution_representations)
      end

      it 'can be written' do
        described_class.new(question).from_json(
          {
            'collaborator_solutions' => [
              {
                'title' => 'Test',
                'solution_type' => 'example',
                'content_html' => 'This is a test.'
              }
            ]
          }.to_json
        )

        expect(question).to have_received(:collaborator_solutions=)
                              .with([a_kind_of(CollaboratorSolution)]) do |collaborator_solutions|
          expect(collaborator_solutions.first.title).to eq 'Test'
          expect(collaborator_solutions.first.solution_type).to eq 'example'
          expect(collaborator_solutions.first.content).to eq 'This is a test.'
        end
      end
    end

    context 'community_solutions' do
      it 'can be read' do
        solutions = [CommunitySolution.new(content: 'Of course.')]
        solution_representations = solutions.collect do |sol|
          CommunitySolutionRepresenter.new(sol).to_hash
        end
        allow(question).to receive(:community_solutions).and_return(solutions)
        expect(representation).to include('community_solutions' => solution_representations)
      end

      it 'cannot be written (attempts are silently ignored)' do
        described_class.new(question).from_json(
          {
            'community_solutions' => [
              {
                'title' => 'Test',
                'solution_type' => 'example',
                'content_html' => 'This is a test.'
              }
            ]
          }.to_json
        )

        expect(question).not_to have_received(:community_solutions=)
      end
    end

    context 'hints' do
      it 'can be read' do
        hints = [Hint.new(content: 'A hint.')]
        hint_representations = hints.collect{ |hint| hint.content }
        allow(question).to receive(:hints).and_return(hints)
        expect(representation).to include('hints' => hint_representations)
      end

      xit 'can be written' do
      end
    end

    context 'parent_dependencies' do
      it 'can be read' do
        parent_dependencies = []
        allow(question).to receive(:parent_dependencies).and_return(parent_dependencies)
        expect(representation).to include('dependencies' => parent_dependencies)
      end

      xit 'can be written' do
      end
    end

  end
end
