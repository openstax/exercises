class AddIsByCollaboratorToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :is_by_collaborator, :boolean, null: false, default: false
    # TODO migrate existing solutions to be by collaborator
  end
end
