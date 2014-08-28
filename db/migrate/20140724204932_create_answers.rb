class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.sortable
      t.references :answerable, polymorphic: true, null: false
      t.text :content, null: false, default: ''
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps
    end

    add_sortable_index :answers, [:answerable_id, :answerable_type],
                       name: 'index_answers_on_a_id_and_a_type_and_sortable_position'
    add_index :answers, :correctness
  end
end
