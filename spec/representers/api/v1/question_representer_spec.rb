require 'rails_helper'

module Api::V1
  RSpec.describe QuestionRepresenter, type: :representer do

    let!(:exercise) {
      dbl = instance_spy(Exercise)
      allow(dbl).to receive(:as_json).and_return(dbl)
      dbl
    }

    let!(:question) {
      dbl = instance_spy(Question)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:stems).and_return([])
      allow(dbl).to receive(:answers).and_return([])
      allow(dbl).to receive(:solutions).and_return([])
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

      xit 'can be written' do
      end
    end

    context 'answers' do
      it 'can be read' do
        answer_1 = instance_spy(Answer)
        allow(answer_1).to receive(:id).and_return(2)
        allow(answer_1).to receive(:as_json).and_return(answer_1)
        allow(answer_1).to receive(:question).and_return(question)
        allow(answer_1).to receive(:content).and_return('No')
        answer_2 = instance_spy(Answer)
        allow(answer_2).to receive(:id).and_return(1)
        allow(answer_2).to receive(:as_json).and_return(answer_2)
        allow(answer_2).to receive(:question).and_return(question)
        allow(answer_2).to receive(:content).and_return('Yes')
        answers = [answer_1, answer_2]
        answer_representations = answers.reverse.collect do |answer|
          AnswerRepresenter.new(answer).to_hash
        end
        allow(question).to receive(:answers).and_return(answers)
        expect(representation).to include('answers' => answer_representations)
      end

      xit 'can be written' do
      end
    end

    context 'solutions' do
      it 'can be read' do
        solutions = [Solution.new(content: 'Of course.')]
        solution_representations = solutions.collect{ |sol| SolutionRepresenter.new(sol).to_hash }
        allow(question).to receive(:solutions).and_return(solutions)
        expect(representation).to include('solutions' => solution_representations)
      end

      xit 'can be written' do
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
