require 'rails_helper'

RSpec.describe Oauth::ApplicationsController, type: :routing do
  context 'GET /oauth/applications' do
    it 'routes to #index' do
      expect(get('/oauth/applications')).to route_to('oauth/applications#index')
    end
  end

  context 'GET /oauth/applications/new' do
    it 'routes to #new' do
      expect(get('/oauth/applications/new')).to route_to('oauth/applications#new')
    end
  end

  context 'GET /oauth/applications/:id' do
    it 'routes to #show' do
      expect(get('/oauth/applications/1')).to route_to('oauth/applications#show', id: '1')
    end
  end

  context 'GET /oauth/applications/:id/edit' do
    it 'routes to #edit' do
      expect(get('/oauth/applications/1/edit')).to route_to('oauth/applications#edit', id: '1')
    end
  end

  context 'POST /oauth/applications' do
    it 'routes to #create' do
      expect(post('/oauth/applications')).to route_to('oauth/applications#create')
    end
  end

  [ :put, :patch ].each do |method|
    context "#{method.to_s.upcase} /oauth/applications/:id" do
      it 'routes to #update' do
        expect(send(method, '/oauth/applications/1')).to(
          route_to('oauth/applications#update', id: '1')
        )
      end
    end
  end

  context 'DELETE /oauth/applications/:id' do
    it 'routes to #destroy' do
      expect(delete('/oauth/applications/1')).to route_to('oauth/applications#destroy', id: '1')
    end
  end
end
