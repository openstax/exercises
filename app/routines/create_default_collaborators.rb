class CreateDefaultCollaborators
  lev_routine

  uses_routine OpenStax::Accounts::FindOrCreateAccount,
               translations: { outputs: { type: :verbatim } },
               as: :find_or_create_account

  protected

  def exec
    author = find_or_create_user(username: 'openstax', name: 'OpenStax')
    ch = find_or_create_user(username: 'riceuniversity', name: 'Rice University')

    outputs[:author] = author
    outputs[:copyright_holder] = ch

    Rails.logger.info "Author: #{author.full_name} (ID: #{author.id})"
    Rails.logger.info "Copyright Holder: #{ch.full_name} (ID: #{ch.id})"
  end

  def find_or_create_account(username:, name:)
    account = OpenStax::Accounts::Account.find_by(username: username) || \
                run(:find_or_create_account, username: username).outputs.account
    account.update_column(:full_name, name)
    account
  end

  def find_or_create_user(username:, name:)
    account = find_or_create_account(username: username, name: name)
    User.find_or_create_by(account: account)
  end
end
