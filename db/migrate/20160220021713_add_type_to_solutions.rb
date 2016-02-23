class AddTypeToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :type, :string, null: false, default: "CollaboratorSolution"
  end
end
