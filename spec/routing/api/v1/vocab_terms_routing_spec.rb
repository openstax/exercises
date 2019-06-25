require 'rails_helper'

RSpec.describe Api::V1::VocabTermsController, type: :routing, api: true, version: :v1 do
  context 'GET /api/vocab_terms' do
    it 'routes to #index' do
      expect(get('/api/vocab_terms')).to route_to('api/v1/vocab_terms#index', format: 'json')
    end
  end

  context 'GET /api/vocab_terms/:id' do
    it 'routes to #show' do
      expect(get('/api/vocab_terms/1')).to(
        route_to('api/v1/vocab_terms#show', id: '1', format: 'json')
      )
    end
  end

  context 'POST /api/vocab_terms' do
    it 'routes to #create' do
      expect(post('/api/vocab_terms')).to route_to('api/v1/vocab_terms#create', format: 'json')
    end
  end

  [ :put, :patch ].each do |method|
    context "#{method.to_s.upcase} /api/vocab_terms/:id" do
      it 'routes to #update' do
        expect(send(method, '/api/vocab_terms/1')).to(
          route_to('api/v1/vocab_terms#update', id: '1', format: 'json')
        )
      end
    end
  end

  context 'DELETE /api/vocab_terms/:id' do
    it 'routes to #destroy' do
      expect(delete('/api/vocab_terms/1')).to(
        route_to('api/v1/vocab_terms#destroy', id: '1', format: 'json')
      )
    end
  end
end
