require 'rails_helper'

RSpec.describe WebviewController, :type => :routing do
  describe 'routing' do

    it 'routes to #home' do
      expect(:get => '/').to route_to('webview#home')
    end

    it 'routes to #index' do
      expect(:get => '/dashboard').to route_to('webview#index')
    end

    it 'catches all other routes' do
      [:get, :post, :put, :patch, :delete].each do |method|
        expect(method => "/#{SecureRandom.hex}").to route_to('webview#index')
      end
    end

  end
end
