require 'rails_helper'

module Api::V1::Exercises
  RSpec.describe SearchRepresenter, type: :representer do

    let(:vocab_term) { FactoryBot.create :vocab_term }
    let(:exercises)  do
      vocab_term.exercises.each do |exercise|
        exercise.title = 'A title'
        exercise.stimulus = 'Stimulus package'
        exercise.save!
      end
    end

    context '#to_hash' do
      it 'preloads only exercises that are not cached' do
        expect_any_instance_of(ActiveRecord::Associations::Preloader).to receive(:preload).with(
          exercises, Exercise::PRELOAD_ASSOCIATIONS
        ).once.and_call_original

        described_class.new(exercises).to_hash(user_options: { can_view_solutions: true })
        described_class.new(exercises).to_hash
        described_class.new(exercises).to_hash
        described_class.new(exercises).to_hash(user_options: { can_view_solutions: true })
      end
    end
  end
end
