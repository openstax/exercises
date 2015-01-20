require 'rails_helper'

RSpec.describe StaticPagesController, :type => :routing do
  describe 'routing' do

    ['about', 'contact', 'copyright', 'developers', 'help',
     'privacy', 'publishing', 'share', 'status', 'terms'].each do |path|
      it "routes to ##{path}" do
        expect(:get => "/#{path}").to route_to("static_pages##{path}")
      end
    end

  end
end
