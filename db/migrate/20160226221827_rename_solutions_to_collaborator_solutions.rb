class RenameSolutionsToCollaboratorSolutions < ActiveRecord::Migration
  def change
    rename_table :solutions, :collaborator_solutions
  end
end
