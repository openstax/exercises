# The rake tasks in this module are used to manage OpenStax oauth applications.
# Currently, only Tutor is managed by these tasks.
namespace :openstax do
  namespace :applications do
    DEFAULT_APP_NAMES = [ 'OpenStax Tutor' ]

    # This task creates applications based on the given parameters.
    # This task creates an user with the username `ose_app_admin` with
    # the given password if one is not found already. It also creates
    # a group `ose_app_admin_group` and assigns the newly created user
    # to that group.  Once the user and the group are setup, it
    # creates each of the applications declared above.
    desc "Create the default OpenStax Applications (currently only Tutor) in OpenStax Exercises"
    task :create, [ :admin_password ] => :environment do |t, args|
      ActiveRecord::Base.transaction do
        # Get the admin password
        password = args[:admin_password]

        # Create application owner if needed
        admin_account = OpenStax::Accounts::FindOrCreateAccount.call(
          username: 'ose_app_admin', password: password
        ).outputs.account
        admin_user = User.find_or_create_by account: admin_account

        DEFAULT_APP_NAMES.each do |app_name|
          # Create the app if it doesn't exist
          Doorkeeper::Application.find_or_create_by(name: app_name) do |application|
            application.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
            application.owner = admin_user

            puts "Created application #{app_name}."
          end
        end
      end
    end

    # This task gets information about all the authorized oauth
    # applications.  For each application found, it returns the
    # application id and secret as a JSON object list.
    desc "Save information about known client applications"
    task :save_json, [ :filename ] => :environment do |t, args|
      filename = args[:filename] || 'client_apps.json'

      apps = Doorkeeper::Application.where(name: DEFAULT_APP_NAMES)

      apps = apps.map do |app|
        { name: app.name, client_id: app.uid, secret: app.secret, redirect_uri: app.redirect_uri }
      end

      File.open(filename, 'w') do |f|
        f.write(JSON.pretty_generate(apps))
        puts "Generated the client application json file @ #{File.expand_path(f.path)}"
      end
    end
  end
end
