require 'rails_helper'

module Api::V1
  RSpec.describe SimpleQuestionRepresenter, type: :representer do

    let!(:stem) {
      dbl = instance_spy(Stem)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:stylings).and_return([])
      allow(dbl).to receive(:stem_answers).and_return([])
      allow(dbl).to receive(:combo_choices).and_return([])
      dbl
    }

    let!(:question) {
      dbl = instance_spy(Question)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:stems).and_return([stem])
      allow(dbl).to receive(:answers).and_return([])
      allow(dbl).to receive(:solutions).and_return([])
      allow(dbl).to receive(:hints).and_return([])
      allow(dbl).to receive(:parent_dependencies).and_return([])
      dbl
    }

    # This is lazily-evaluated on purpose
    let(:representation) {
      described_class.new(question).as_json
    }

    context 'id' do
      it 'can be read' do
        allow(question).to receive(:id).and_return(21)
        expect(representation).to include('id' => 21)
      end

      it 'cannot be written (attempts are silently ignored)' do
        described_class.new(question).from_json({'id' => 42}.to_json)
        expect(question).to_not have_received(:id=)
        expect(question).to_not have_received(:temp_id=)
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

    context 'stem_html' do
      it 'can be read' do
        stem = Stem.new(content: 'Don\'t you agree?')
        stem_representation = stem.content
        allow(question).to receive(:stems).and_return([stem])
        expect(representation).to include('stem_html' => stem_representation)
      end

      xit 'can be written' do
      end
    end

    context 'answers' do
      it 'can be read' do
        answers = [Answer.new(content: 'Yes'), Answer.new(content: 'No')]
        answer_representations = answers.collect{ |answer| AnswerRepresenter.new(answer).to_hash }
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

  end
end
