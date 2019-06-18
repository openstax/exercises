class RenameDeputizationsToDelegations < ActiveRecord::Migration[5.2]
  def change
    remove_index :deputizations, column: [ :deputy_id, :deputy_type, :deputizer_id ],
                                 name: 'index_deputizations_on_d_id_and_d_type_and_d_id',
                                 unique: true

    rename_table :deputizations, :delegations

    rename_column :delegations, :deputizer_id, :delegator_id
    rename_column :delegations, :deputy_id, :delegate_id

    remove_column :delegations, :deputy_type, :string, null: false

    add_column :delegations, :can_create,  :boolean, default: false, null: false
    add_column :delegations, :can_read,    :boolean, default: true,  null: false
    add_column :delegations, :can_update,  :boolean, default: false, null: false
    add_column :delegations, :can_destroy, :boolean, default: false, null: false

    add_index :delegations, [ :delegate_id, :delegator_id ], unique: true
    add_index :delegations, :delegate_id, where: :can_read,
                                          name: 'index_read_delegations_on_delegate_id'
  end
end
