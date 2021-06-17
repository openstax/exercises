class AddSolutionsArePublicToPublicationGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :publication_groups, :solutions_are_public, :boolean, default: false

    PublicationGroup.where(publishable_type: 'VocabTerm').update_all solutions_are_public: true

    change_column_null :publication_groups, :solutions_are_public, false
  end
end
