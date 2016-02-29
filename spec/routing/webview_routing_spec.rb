require 'rails_helper'

RSpec.describe WebviewController, type: :routing do
  describe 'routing' do

    it 'routes to #home' do
      expect(get: '/').to route_to('webview#home')
    end

    it 'routes to #index' do
      expect(get: '/exercises/1').to route_to('webview#index', path: 'exercises/1')
    end

    it 'catches all other routes' do
      [:get, :post, :put, :patch, :delete].each do |method|
        path = SecureRandom.hex
        expect(method => "/#{path}").to route_to('webview#index', path: path)
      end
    end

  end
end
