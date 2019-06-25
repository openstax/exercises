require 'rails_helper'

RSpec.describe Admin::ConsoleController, type: :routing do
  context 'GET /admin' do
    it 'routes to #index' do
      expect(get: '/admin').to route_to('admin/console#index')
    end
  end
end
