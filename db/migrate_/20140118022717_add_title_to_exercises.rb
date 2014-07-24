class AddTitleToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :title, :string
  end
end
