secrets = Rails.application.secrets['a15k']

A15kClient.configure do |c|
  c.scheme = secrets['scheme']
  c.host = secrets['host']
  c.api_key['Authorization'] = secrets['access_token']
end
