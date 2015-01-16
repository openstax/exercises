require 'rails_helper'

RSpec.describe StaticPagesController, :type => :routing do
  describe 'routing' do

    it 'routes to #about' do
      expect(:get => '/about').to route_to('static_pages#about')
    end

  end
end
