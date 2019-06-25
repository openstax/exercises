require 'rails_helper'

RSpec.describe Api::V1::PublicationsController, type: :routing, api: true, version: :v1 do
  { exercises: { exercise_id: '1' }, vocab_terms: { vocab_term_id: '1' } }.each do |path, params|
    context "PUT /api/#{path}/:id/publish" do
      it 'routes to #publish' do
        expect(put("/api/#{path}/1/publish")).to(
          route_to('api/v1/publications#publish', { format: 'json' }.merge(params))
        )
      end
    end
  end
end
