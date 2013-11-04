class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.belongs_to :user, null: false
      t.belongs_to :default_list, null: false
      t.boolean :auto_author_subscribe, null: false, default: false
      t.boolean :announcement_email, null: false, default: false
      t.boolean :collaborator_request_email, null: false, default: false
      t.boolean :user_group_member_email, null: false, default: false

      t.timestamps
    end

    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :default_list_id
  end
end
