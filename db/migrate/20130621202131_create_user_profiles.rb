class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.boolean :group_member_email
      t.boolean :collaborator_request_email
      t.boolean :announcement_email
      t.boolean :auto_author_subscribe

      t.timestamps
    end
  end
end
