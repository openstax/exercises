class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.integer :creator_id
      t.string :subject
      t.text :body
      t.boolean :force

      t.timestamps
    end

    add_index :announcements, :creator_id
  end
end
