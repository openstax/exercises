class CreateTermTags < ActiveRecord::Migration
  def change
    create_table :term_tags do |t|
      t.references :term, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :tag, index: true, foreign_key: { on_update: :cascade,
                                                     on_delete: :cascade }

      t.timestamps null: false

      t.index [:term_id, :tag_id], unique: true
    end
  end
end
