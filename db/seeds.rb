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

# Question Formats
Format.create do |format|
  format.name        = 'multiple_choice'
  format.title       = 'Multiple Choice'
  format.description = 'A format that presents several possible answers and allows only one of them to be chosen'
end

Format.create do |format|
  format.name        = 'multiple_select'
  format.title       = 'Multiple Select'
  format.description = 'A format that presents several possible answers and allows any number of them to be chosen'
end

Format.create do |format|
  format.name        = 'short_answer'
  format.title       = 'Short Answer'
  format.description = 'A format that allows short text or numbers to be entered'
end

Format.create do |format|
  format.name        = 'fill_in_the_blank'
  format.title       = 'Fill in the Blank'
  format.description = 'A format that allows short text or numbers to be inserted inside the question text'
end

Format.create do |format|
  format.name        = 'point_and_click'
  format.title       = 'Point and Click'
  format.description = 'A format that allows the user to click an object'
end

Format.create do |format|
  format.name        = 'matching'
  format.title       = 'Matching'
  format.description = 'A format that allows the user to match columns of objects'
end

Format.create do |format|
  format.name        = 'sorting'
  format.title       = 'Sorting'
  format.description = 'A format that allows the user to sort objects'
end

Format.create do |format|
  format.name        = 'free_response'
  format.title       = 'Free Response'
  format.description = 'A format that allows any text to be entered'
end

# Content Licenses
License.create do |license|
  license.name                 = 'cc_by_4_0'
  license.title                = 'Creative Commons Attribution 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.class_licenses       << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution = true
  license.share_alike          = false
  license.non_commercial       = false
  license.no_derivatives       = false
end

License.create do |license|
  license.name                 = 'cc_by-sa_4_0'
  license.title                = 'Creative Commons Attribution-ShareAlike 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by-sa/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.class_licenses       << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution = true
  license.non_commercial       = false
  license.share_alike          = true
  license.no_derivatives       = false
end

License.create do |license|
  license.name                 = 'cc_by-nc_4_0'
  license.title                = 'Creative Commons Attribution-NonCommercial 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by-nc/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.class_licenses       << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution = true
  license.non_commercial       = true
  license.share_alike          = false
  license.no_derivatives       = false
end

License.create do |license|
  license.name                 = 'cc_by-nc-sa_4_0'
  license.title                = 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by-nc-sa/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.class_licenses       << ClassLicense.new(class_name: 'Exercise')
  license.requires_attribution = true
  license.non_commercial       = true
  license.share_alike          = true
  license.no_derivatives       = false
end

License.create do |license|
  license.name                 = 'cc_by-nd_4_0'
  license.title                = 'Creative Commons Attribution-NoDerivatives 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by-nd/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.requires_attribution = true
  license.non_commercial       = false
  license.share_alike          = false
  license.no_derivatives       = true
end

License.create do |license|
  license.name                 = 'cc_by-nc-nd_4_0'
  license.title                = 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International'
  license.url                  = 'http://creativecommons.org/licenses/by-nc-nd/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.requires_attribution = true
  license.non_commercial       = true
  license.share_alike          = false
  license.no_derivatives       = true
end

License.create do |license|
  license.name                 = 'cc0_1_0'
  license.title                = 'Creative Commons CC0 1.0 Universal'
  license.url                  = 'http://creativecommons.org/licenses/zero/1.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.class_licenses       << ClassLicense.new(class_name: 'Exercise')
  license.class_licenses       << ClassLicense.new(class_name: 'Solution')
  license.class_licenses       << ClassLicense.new(class_name: 'List')
  license.requires_attribution = false
  license.non_commercial       = false
  license.share_alike          = false
  license.no_derivatives       = false
end

# Logic Library Languages
Language.create do |language|
  language.name = 'javascript'
  language.title = 'JavaScript'
  language.description = 'Language for Logic objects'
end

Language.create do |language|
  language.name = 'lateX'
  language.title = 'LaTeX'
  language.description = 'Language for math input'
end

# TODO: Standard libraries (plus RequiredLibrary objects)
