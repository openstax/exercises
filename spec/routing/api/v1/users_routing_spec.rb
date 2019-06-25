require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing, api: true, version: :v1 do
  context 'GET /api/users' do
    it 'routes to #index' do
      expect(get('/api/users')).to route_to('api/v1/users#index', format: 'json')
    end
  end

  context 'GET /api/user' do
    it 'routes to #show' do
      expect(get('/api/user')).to route_to('api/v1/users#show', format: 'json')
    end
  end

  [ :put, :patch ].each do |method|
    context "#{method.to_s.upcase} /api/user" do
      it 'routes to #update' do
        expect(send(method, '/api/user')).to route_to('api/v1/users#update', format: 'json')
      end
    end
  end

  context 'DELETE /api/user' do
    it 'routes to #destroy' do
      expect(delete('/api/user')).to route_to('api/v1/users#destroy', format: 'json')
    end
  end
end
