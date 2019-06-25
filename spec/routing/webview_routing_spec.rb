require 'rails_helper'

RSpec.describe WebviewController, type: :routing do
  context 'GET /' do
    it 'routes to #home' do
      expect(get: '/').to route_to('webview#home')
    end
  end

  context 'GET /*path' do
    it 'routes to #index' do
      expect(get: '/exercises/1').to route_to('webview#index', path: 'exercises/1')

      path = SecureRandom.hex
      expect(get: "/#{path}").to route_to('webview#index', path: path)
    end
  end
end
