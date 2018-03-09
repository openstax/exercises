require 'rails_helper'

RSpec.describe Api::V1::ExercisesController, type: :routing, api: true, version: :v1 do
  it 'routes to #index' do
    expect(get('/api/exercises')).to(
      route_to('api/v1/exercises#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('/api/exercises/1')).to(
      route_to('api/v1/exercises#show', id: '1', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(post('/api/exercises')).to(
      route_to('api/v1/exercises#create', format: 'json')
    )
  end

  it 'routes to #update' do
    [:put, :patch].each do |method|
      expect(send(method, '/api/exercises/1')).to(
        route_to('api/v1/exercises#update', id: '1', format: 'json')
      )
    end
  end

  it 'routes to #destroy' do
    expect(delete('/api/exercises/1')).to(
      route_to('api/v1/exercises#destroy', id: '1', format: 'json')
    )
  end

  it 'routes to #versions' do
    expect(get('/api/exercises/1/versions')).to(
      route_to('api/v1/exercises#versions', id: '1', format: 'json')
    )
  end
end
