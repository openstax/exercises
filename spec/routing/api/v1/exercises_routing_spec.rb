require 'rails_helper'

RSpec.describe Api::V1::ExercisesController, type: :routing, api: true, version: :v1 do
  context 'GET /api/exercises' do
    it 'routes to #index' do
      expect(get('/api/exercises')).to route_to('api/v1/exercises#index', format: 'json')
    end
  end

  context 'GET /api/exercises/:id' do
    it 'routes to #show' do
      expect(get('/api/exercises/1')).to route_to('api/v1/exercises#show', id: '1', format: 'json')
    end
  end

  context 'POST /api/exercises' do
    it 'routes to #create' do
      expect(post('/api/exercises')).to route_to('api/v1/exercises#create', format: 'json')
    end
  end

  [ :put, :patch ].each do |method|
    context "#{method.to_s.upcase} /api/exercises/:id" do
      it 'routes to #update' do
        expect(send(method, '/api/exercises/1')).to(
          route_to('api/v1/exercises#update', id: '1', format: 'json')
        )
      end
    end
  end

  context 'DELETE /api/exercises/:id' do
    it 'routes to #destroy' do
      expect(delete('/api/exercises/1')).to(
        route_to('api/v1/exercises#destroy', id: '1', format: 'json')
      )
    end
  end
end
