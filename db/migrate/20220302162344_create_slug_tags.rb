class CreateSlugTags < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    Exercise.preload(:publication).in_batches(of: 100, load: true) do |exercises|
      Exercise.transaction do
        exercises.each(&:save) # creates the slug tags but does not set updated_at
        exercises.update_all(updated_at: Time.current) # invalidates the exercise cache
      end
    end
  end

  def down
  end
end
