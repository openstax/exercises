# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# FinePrint Contracts
FinePrint::Contract.create do |contract|
  contract.name    = 'general_terms_of_use'
  contract.version = 1
  contract.title   = 'Terms of Use'
  contract.content = 'Placeholder for general terms of use, required for new installations to function'
end

FinePrint::Contract.create do |contract|
  contract.name    = 'privacy_policy'
  contract.version = 1
  contract.title   = 'Privacy Policy'
  contract.content = 'Placeholder for privacy policy, required for new installations to function'
end

FinePrint::Contract.create do |contract|
  contract.name    = 'publishing_agreement'
  contract.version = 1
  contract.title   = 'Content Publishing Agreement'
  contract.content = 'Placeholder for agreement to publish content under the available licenses, required for new installations to function'
end

# Content Licenses
License.create do |license|
  license.name                  = 'cc_by_4_0'
  license.title                 = 'Creative Commons Attribution 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.class_licenses        << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution  = true
  license.requires_share_alike  = false
  license.allows_commercial_use = true
  license.allows_derivatives    = true
end

License.create do |license|
  license.name                  = 'cc_by-sa_4_0'
  license.title                 = 'Creative Commons Attribution-ShareAlike 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by-sa/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.class_licenses        << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution  = true
  license.requires_share_alike  = true
  license.allows_commercial_use = true
  license.allows_derivatives    = true
end

License.create do |license|
  license.name                  = 'cc_by-nc_4_0'
  license.title                 = 'Creative Commons Attribution-NonCommercial 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by-nc/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.class_licenses        << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution  = true
  license.requires_share_alike  = false
  license.allows_commercial_use = false
  license.allows_derivatives    = true
end

License.create do |license|
  license.name                  = 'cc_by-nc-sa_4_0'
  license.title                 = 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by-nc-sa/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.class_licenses        << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution  = true
  license.requires_share_alike  = true
  license.allows_commercial_use = false
  license.allows_derivatives    = true
end

License.create do |license|
  license.name                  = 'cc_by-nd_4_0'
  license.title                 = 'Creative Commons Attribution-NoDerivatives 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by-nd/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.requires_attribution  = true
  license.requires_share_alike  = false
  license.allows_commercial_use = true
  license.allows_derivatives    = false
end

License.create do |license|
  license.name                  = 'cc_by-nc-nd_4_0'
  license.title                 = 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International'
  license.url                   = 'http://creativecommons.org/licenses/by-nc-nd/4.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.requires_attribution  = true
  license.requires_share_alike  = false
  license.allows_commercial_use = false
  license.allows_derivatives    = false
end

License.create do |license|
  license.name                  = 'cc0_1_0'
  license.title                 = 'Creative Commons CC0 1.0 Universal'
  license.url                   = 'http://creativecommons.org/licenses/zero/1.0/'
  license.publishing_contract   = 'publishing_contract placeholder'
  license.copyright_notice      = 'copyright_notice placeholder'
  license.class_licenses        << ClassLicense.new(class_name: 'Exercise')
  license.class_licenses        << ClassLicense.new(class_name: 'CommunitySolution')
  license.class_licenses        << ClassLicense.new(class_name: 'List')
  license.requires_attribution  = false
  license.requires_share_alike  = false
  license.allows_commercial_use = true
  license.allows_derivatives    = true
end

# Output logging info to stdout
original_logger = Rails.logger
begin
  Rails.logger = ActiveSupport::Logger.new(STDOUT)

  CreateDefaultCollaborators.call
ensure
  # Restore original logger
  Rails.logger = original_logger
end

# TODO: Standard logic libraries (and RequiredLibrary objects)
