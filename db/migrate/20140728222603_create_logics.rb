class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.references :logicable, polymorphic: true, null: false
      t.references :language, null: false
      t.text :code, null: false, default: ''

      t.timestamps
    end

    add_index :logics, [:logicable_id, :logicable_type, :language_id], unique: true,
              name: 'index_logics_on_l_id_and_l_type_and_l_id'
    add_index :logics, :language_id
  end
end
