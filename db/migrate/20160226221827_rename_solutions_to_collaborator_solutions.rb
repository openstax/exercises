class RenameSolutionsToCollaboratorSolutions < ActiveRecord::Migration
  def up
    # Transfer any solution Attachments to their Exercises
    Attachment.where(parent_type: 'Solution').preload(:parent).find_each do |attachment|
      attachment.update_attribute(:parent, attachment.parent.question.exercise)
    end
    # Update all Logics, Stylings and Votes to point to the new table
    Logic.where(parent_type: 'Solution').update_all(parent_type: 'CollaboratorSolution')
    Styling.where(stylable_type: 'Solution').update_all(stylable_type: 'CollaboratorSolution')
    ActsAsVotable::Vote.where(votable_type: 'Solution')
                       .update_all(votable_type: 'CollaboratorSolution')

    # Remove all CollaboratorSolution Publication objects
    Publication.where(publishable_type: 'Solution').destroy_all

    rename_table :solutions, :collaborator_solutions
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
          "Can't recover the moved Attachments and deleted Publications"
  end
end
