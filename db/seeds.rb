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
  format.name        = 'Multiple Choice'
  format.description = 'A format that presents several possible answers and allows only one of them to be chosen'
end

Format.create do |format|
  format.name        = 'Multiple Select'
  format.description = 'A format that presents several possible answers and allows any number of them to be chosen'
end

Format.create do |format|
  format.name        = 'Short Answer'
  format.description = 'A format that allows short text or numbers to be entered'
end

Format.create do |format|
  format.name        = 'Fill in the Blank'
  format.description = 'A format that allows short text or numbers to be inserted inside the question text'
end

Format.create do |format|
  format.name        = 'Point and Click'
  format.description = 'A format that allows the user to click an object'
end

Format.create do |format|
  format.name        = 'Matching'
  format.description = 'A format that allows the user to match columns of objects'
end

Format.create do |format|
  format.name        = 'Sorting'
  format.description = 'A format that allows the user to sort objects'
end

Format.create do |format|
  format.name        = 'Free Response'
  format.description = 'A format that allows any text to be entered'
end

# Content Licenses
License.create do |license|
  license.name                 = 'Creative Commons Attribution 4.0 International'
  license.short_name           = 'CC BY 4.0'
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
  license.name                 = 'Creative Commons Attribution-ShareAlike 4.0 International'
  license.short_name           = 'CC BY-SA 4.0'
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
  license.name                 = 'Creative Commons Attribution-NonCommercial 4.0 International'
  license.short_name           = 'CC BY-NC 4.0'
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
  license.name                 = 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International'
  license.short_name           = 'CC BY-NC-SA 4.0'
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
  license.name                 = 'Creative Commons Attribution-NoDerivatives 4.0 International'
  license.short_name           = 'CC BY-ND 4.0'
  license.url                  = 'http://creativecommons.org/licenses/by-nd/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.requires_attribution = true
  license.non_commercial       = false
  license.share_alike          = false
  license.no_derivatives       = true
end

License.create do |license|
  license.name                 = 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International'
  license.short_name           = 'CC BY-NC-ND 4.0'
  license.url                  = 'http://creativecommons.org/licenses/by-nc-nd/4.0/'
  license.publishing_contract  = 'publishing_contract placeholder'
  license.copyright_notice     = 'copyright_notice placeholder'
  license.requires_attribution = true
  license.non_commercial       = true
  license.share_alike          = false
  license.no_derivatives       = true
end

License.create do |license|
  license.name                 = 'Creative Commons CC0 1.0 Universal'
  license.short_name           = 'CC0 1.0'
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
  language.name = 'JavaScript'
  language.description = 'Language for Logic objects'
end

Language.create do |language|
  language.name = 'LaTeX'
  language.description = 'Language for math input'
end

# TODO: Standard libraries (plus RequiredLibrary objects)
