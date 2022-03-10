class UpdateSlugs
  lev_routine transaction: :no_transaction

  protected

  def exec
    Exercise.preload(:publication).in_batches(of: 100, load: true) do |exercises|
      Exercise.transaction do
        updated_exercise_ids = exercises.filter(&:set_slug_tags!).map(&:id)
        next if updated_exercise_ids.empty?

        Exercise.where(id: updated_exercise_ids).update_all updated_at: Time.current
      end
    end
  end
end
