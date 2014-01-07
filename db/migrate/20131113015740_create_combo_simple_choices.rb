class CreateComboSimpleChoices < ActiveRecord::Migration
  def change
    create_table :combo_simple_choices do |t|
      t.integer :combo_choice_id
      t.integer :simple_choice_id

      t.timestamps
    end

    add_index :combo_simple_choices, :combo_choice_id
    add_index :combo_simple_choices, :simple_choice_id
    add_index :combo_simple_choices, [:combo_choice_id, :simple_choice_id], name: 'index_combo_simple_choices_cc_id_and_sc_id', unique: true
  end
end
