# This migration comes from openstax_accounts (originally 10)
class AssignMissingUuidsForLocalAccounts < ActiveRecord::Migration[4.2]
  def change
    enable_extension :pgcrypto

    change_column :openstax_accounts_accounts, :uuid, :uuid, using: 'uuid::uuid',
                                                             default: 'gen_random_uuid()',
                                                             null: false
  end
end
