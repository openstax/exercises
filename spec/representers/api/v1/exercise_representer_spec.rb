require 'rails_helper'

module Api::V1
  RSpec.describe ExerciseRepresenter, type: :representer do

    let(:exercise) {
      dbl = instance_spy(Exercise)
      allow(dbl).to receive(:as_json).and_return(dbl)
      allow(dbl).to receive(:questions).and_return([])
      allow(dbl).to receive(:attachments).and_return([])
      allow(dbl).to receive(:tags).and_return([])
      allow(dbl).to receive(:logic).and_return(nil)
      allow(dbl).to receive(:license).and_return(nil)
      allow(dbl).to receive(:editors).and_return([])
      allow(dbl).to receive(:authors).and_return([])
      allow(dbl).to receive(:copyright_holders).and_return([])
      allow(dbl).to receive(:derivations).and_return([])
      dbl
    }

    # This is lazily-evaluated on purpose
    let(:representation) { described_class.new(exercise).as_json }

    context 'vocab_term_uid' do
      it 'can be read' do
        vocab_term = instance_spy(VocabTerm)
        allow(vocab_term).to receive(:as_json).and_return(vocab_term)
        allow(vocab_term).to receive(:uid).and_return('42@1')
        allow(exercise).to receive(:vocab_term).and_return(vocab_term)
        expect(representation).to include('vocab_term_uid' => '42@1')
      end

      it 'cannot be written (attempts are silently ignored)' do
        described_class.new(exercise).from_json({'vocab_term_uid' => '42@1'}.to_json)
        expect(exercise).not_to have_received(:vocab_term=)
        expect(exercise).not_to have_received(:vocab_term_id=)
      end
    end

    context 'title' do
      it 'can be read' do
        allow(exercise).to receive(:title).and_return('A cool exercise')
        expect(representation).to include('title' => 'A cool exercise')
      end

      it 'can be written' do
        described_class.new(exercise).from_json({'title' => 'A cooler exercise'}.to_json)
        expect(exercise).to have_received(:title=).with('A cooler exercise')
      end
    end

    context 'stimulus' do
      it 'can be read' do
        allow(exercise).to receive(:stimulus).and_return('This exercise is cool.')
        expect(representation).to include('stimulus_html' => 'This exercise is cool.')
      end

      it 'can be written' do
        described_class.new(exercise)
                       .from_json({'stimulus_html' => 'This exercise is cooler.'}.to_json)
        expect(exercise).to have_received(:stimulus=).with('This exercise is cooler.')
      end
    end

    context 'questions' do
      it 'can be read' do
        question_1 = instance_spy(Question)
        allow(question_1).to receive(:id).and_return(1)
        allow(question_1).to receive(:sort_position).and_return(2)
        allow(question_1).to receive(:stimulus).and_return('Question 2')
        question_2 = instance_spy(Question)
        allow(question_2).to receive(:id).and_return(2)
        allow(question_2).to receive(:sort_position).and_return(1)
        allow(question_2).to receive(:stimulus).and_return('Question 1')
        question_3 = instance_spy(Question)
        allow(question_3).to receive(:id).and_return(3)
        allow(question_3).to receive(:sort_position).and_return(3)
        allow(question_3).to receive(:stimulus).and_return('Question 3')

        sorted_questions = [question_2, question_1, question_3]

        question_representations = sorted_questions.map do |question|
          allow(question).to receive(:as_json).and_return(question)
          allow(question).to receive(:exercise).and_return(exercise)
          allow(question).to receive(:stems).and_return([])
          allow(question).to receive(:answers).and_return([])
          allow(question).to receive(:collaborator_solutions).and_return([])
          allow(question).to receive(:community_solutions).and_return([])
          allow(question).to receive(:hints).and_return([])
          allow(question).to receive(:parent_dependencies).and_return([])
          SimpleQuestionRepresenter.new(question).to_hash
        end

        allow(exercise).to receive(:questions).and_return(sorted_questions)

        expect(representation).to include('questions' => question_representations)
      end

      it 'can be written' do
        # instance_spy doesn't work here because the Questions being created expect a real Exercise
        real_ex = FactoryGirl.build :exercise

        expect(real_ex).to receive(:questions=)
                             .with(3.times.map{ a_kind_of(Question) }) do |questions|
          expect(questions.first.stimulus).to  eq 'Question 1'
          expect(questions.second.stimulus).to eq 'Question 2'
          expect(questions.third.stimulus).to  eq 'Question 3'
        end

        described_class.new(real_ex).from_json({'questions' => [
          { 'stimulus_html' => 'Question 1' },
          { 'stimulus_html' => 'Question 2' },
          { 'stimulus_html' => 'Question 3' }
        ]}.to_json)
      end
    end

  end
end
