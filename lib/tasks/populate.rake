# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

namespace :db do
  task :populate_users => :environment do
    create_user("Admin", "Jones")
    create_user("User", "Jones")
    first_names = ["Prof", "Student", "Alice", "Bob", "Carlos", "Carol", "Charlie", "Chuck", "Dave",
                   "Eve", "Fuego", "Mallory", "Peggy", "Trent", "Trudy", "Walter"]
    first_names.each { |fn| create_user(fn) }
  end

  task :populate => [:populate_users]  

  def create_user(first_name = Faker::Name::first_name, last_name = Faker::Name::last_name)
    u = User.new(:email => first_name.downcase + "@example.com",
                 :password => "password")
    u.first_name = first_name
    u.last_name = last_name
    u.username = first_name.downcase
    u.save!
    u.confirm!
  end
end
