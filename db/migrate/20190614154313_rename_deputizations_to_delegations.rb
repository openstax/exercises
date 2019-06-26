class RenameDeputizationsToDelegations < ActiveRecord::Migration[5.2]
  def change
    remove_index :deputizations, column: [ :deputy_id, :deputy_type, :deputizer_id ],
                                 name: 'index_deputizations_on_d_id_and_d_type_and_d_id',
                                 unique: true

    rename_table :deputizations, :delegations

    rename_column :delegations, :deputizer_id, :delegator_id
    rename_column :delegations, :deputy_id, :delegate_id
    rename_column :delegations, :deputy_type, :delegate_type

    add_column :delegations, :can_assign_authorship, :boolean, null: false
    add_column :delegations, :can_assign_copyright,  :boolean, null: false
    add_column :delegations, :can_read,              :boolean, null: false
    add_column :delegations, :can_update,            :boolean, null: false

    add_index :delegations, [ :delegate_id, :delegator_id, :delegate_type ],
              unique: true,
              name: 'index_delegations_on_delegate_delegator'
    add_index :delegations, [ :delegate_id, :delegator_id, :delegate_type ],
              where: 'can_read',
              unique: true,
              name: 'index_read_delegations_on_delegate_delegator'
    add_index :delegations, [ :delegate_id, :delegator_id, :delegate_type ],
              where: 'can_update',
              unique: true,
              name: 'index_update_delegations_on_delegate_delegator'
  end
end
