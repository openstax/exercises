class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :answerable, polymorphic: true, null: false
      t.text :content, null: false, default: ''
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps
    end

    add_index :answers, [:answerable_id, :answerable_type]
    add_index :answers, :correctness
  end
end
