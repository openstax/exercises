class RenameSolutionsToCollaboratorSolutions < ActiveRecord::Migration[4.2]
  def change
    rename_table :solutions, :collaborator_solutions
  end
end
