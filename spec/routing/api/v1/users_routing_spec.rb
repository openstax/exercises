require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing, api: true, version: :v1 do
  it 'routes to #index' do
    expect(get('/api/users')).to(
      route_to('api/v1/users#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('/api/user')).to(
      route_to('api/v1/users#show', format: 'json')
    )
  end

  it 'routes to #update' do
    [:put, :patch].each do |method|
      expect(send(method, '/api/user')).to(
        route_to('api/v1/users#update', format: 'json')
      )
    end
  end

  it 'routes to #destroy' do
    expect(delete('/api/user')).to(
      route_to('api/v1/users#destroy', format: 'json')
    )
  end
end
