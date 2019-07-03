class RemoveCommontator < ActiveRecord::Migration[5.2]
  def change
    drop_table :commontator_threads
    drop_table :commontator_comments
    drop_table :commontator_subscriptions
  end
end
