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
