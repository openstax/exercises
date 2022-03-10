class CreateSlugTags < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    Exercise.preload(:publication).in_batches(of: 100, load: true) do |exercises|
      Exercise.transaction do
        exercises.each(&:set_slug_tags!)
        exercises.update_all updated_at: Time.current
      end
    end
  end

  def down
  end
end
