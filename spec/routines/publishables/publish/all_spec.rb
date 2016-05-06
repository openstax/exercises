require 'rails_helper'

module Publishables::Publish
  RSpec.describe All, type: :routine do
    let!(:published_exercise) { FactoryGirl.create :exercise, :published }
    let!(:published_solution) { FactoryGirl.create :community_solution, :published }

    let!(:exercise_1)         { FactoryGirl.create :exercise }
    let!(:exercise_2)         { FactoryGirl.create :exercise }

    let!(:solution_1)         { FactoryGirl.create :community_solution }
    let!(:solution_2)         { FactoryGirl.create :community_solution }

    it 'publishes all unpublished publishables' do
      exercise_published_at = published_exercise.published_at
      solution_published_at = published_solution.published_at

      Publishables::Publish::All.call

      expect(published_exercise.published_at).to eq (exercise_published_at)
      expect(published_solution.published_at).to eq (solution_published_at)

      expect(exercise_1.reload.is_published?).to eq true
      expect(exercise_2.reload.is_published?).to eq true

      expect(solution_1.reload.is_published?).to eq true
      expect(solution_2.reload.is_published?).to eq true
    end
  end
end
