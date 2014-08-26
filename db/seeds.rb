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
   contract.name    = 'publishing_agreement'
   contract.content = 'Placeholder for agreement to publish content under the available licenses'
   contract.title   = 'Content Publishing Agreement'
 end).publish

License.create do |license|
  license.name                     = "Creative Commons Attribution 4.0 Unported"
  license.short_name               = "CC BY 4.0"
  license.url                      = "http://creativecommons.org/licenses/by/4.0/"
  license.publishing_contract      = "publishing_contract placeholder"
  license.copyright_notice         = "copyright_notice placeholder"
  license.allows_exercises         = true
  license.allows_solutions         = true
  license.is_public_domain         = false
end

License.create do |license|
  license.name                     = "Creative Commons CC0 1.0 Universal"
  license.short_name               = "CC0 1.0"
  license.url                      = "http://creativecommons.org/licenses/zero/1.0/"
  license.publishing_contract      = "publishing_contract placeholder"
  license.copyright_notice         = "copyright_notice placeholder"
  license.allows_exercises         = true
  license.allows_solutions         = true
  license.is_public_domain         = true
end
