class AddContextToExercises < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :context, :text
  end
end
