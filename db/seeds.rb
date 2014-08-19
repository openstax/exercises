# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(FinePrint::Contract.create do |contract|
   contract.name    = 'general_terms_of_use'
   contract.content = 'Placeholder for general terms of use, required for new installations to function'
   contract.title   = 'Terms of Use'
 end).publish

(FinePrint::Contract.create do |contract|
   contract.name    = 'privacy_policy'
   contract.content = 'Placeholder for privacy policy, required for new installations to function'
   contract.title   = 'Privacy Policy'
 end).publish

(FinePrint::Contract.create do |contract|
   contract.name    = 'publish_cc_by_3_0'
   contract.content = 'Placeholder for agreement to publish content under the CC BY 3.0 license'
   contract.title   = 'Content Publishing Agreement: CC-BY 3.0'
 end).publish

License.create do |license|
  license.short_name               = "CC BY 3.0"
  license.name                     = "Creative Commons Attribution 3.0 Unported"
  license.url                      = "http://creativecommons.org/licenses/by/3.0/"
  license.publishing_contract      = "publish_cc_by_3_0"
  license.allows_exercises         = true
  license.allows_solutions         = true
  license.allows_rubrics           = true
end
