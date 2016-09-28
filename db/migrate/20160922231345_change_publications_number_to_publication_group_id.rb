class ChangePublicationsNumberToPublicationGroupId < ActiveRecord::Migration
  def up
    add_column :publications, :publication_group_id, :integer

    number_publishable_type_pairs = Publication.unscoped.uniq.pluck(:number, :publishable_type)
    number_publishable_type_pairs.each do |number, publishable_type|
      publication_group = PublicationGroup.create! number: number,
                                                   publishable_type: publishable_type

      Publication.unscoped.where(number: number, publishable_type: publishable_type)
                 .update_all(publication_group_id: publication_group.id)
    end

    change_column_null :publications, :publication_group_id, false
    add_index :publications, :publication_group_id
    remove_column :publications, :number
  end

  def down
  end
end
