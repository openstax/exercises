class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.references :publishable, polymorphic: true, null: false
      t.references :license
      t.integer :number, null: false
      t.integer :version, null: false
      t.datetime :published_at
      t.datetime :yanked_at
      t.datetime :embargoed_until
      t.boolean :embargo_children_only, null: false, default: false
      t.boolean :major_change, null: false, default: false

      t.timestamps
    end

    add_index :publications, [:publishable_id, :publishable_type], unique: true
    add_index :publications, [:number, :publishable_type, :version], unique: true
    add_index :publications, :license_id
    add_index :publications, :published_at
    add_index :publications, :yanked_at
    add_index :publications, :embargoed_until
    if supports_partial_index?
      add_index :publications, :embargoed_until, where: 'embargo_children_only=0',
                name: 'filtered_index_publications_on_embargoed_until'
      add_index :publications, [:number, :publishable_type, :version],
                where: 'major_change=0',
                name: 'filtered_index_publications_on_number_and_p_type_and_version'
    end
  end
end
