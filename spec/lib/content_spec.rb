require 'rails_helper'

RSpec.describe Content do
  describe '.slugs_by_page_uuid' do
    let(:abl) { instance_double(OpenStax::Content::Abl) }
    let(:digest) { 'test_digest_123' }
    let(:cache_key) { "slugs_by_page_uuid/#{digest}" }
    let(:result_data) { { 'page-uuid-1' => 'slug-1', 'page-uuid-2' => 'slug-2' } }

    before do
      allow(OpenStax::Content::Abl).to receive(:new).and_return(abl)
      allow(abl).to receive(:digest).and_return(digest)
      allow(RequestStore).to receive(:store).and_return({})
    end

    context 'when value exists in RequestStore' do
      before do
        RequestStore.store[:slugs_by_page_uuid] = result_data
      end

      it 'returns the cached value from RequestStore without calling Abl' do
        expect(abl).not_to receive(:slugs_by_page_uuid)
        expect(Rails.cache).not_to receive(:read)

        expect(Content.slugs_by_page_uuid).to eq(result_data)
      end
    end

    context 'when value exists in Rails cache but not RequestStore' do
      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(result_data)
      end

      it 'returns the cached value and stores it in RequestStore' do
        expect(abl).not_to receive(:slugs_by_page_uuid)

        result = Content.slugs_by_page_uuid

        expect(result).to eq(result_data)
        expect(RequestStore.store[:slugs_by_page_uuid]).to eq(result_data)
      end
    end

    context 'when value is not cached anywhere' do
      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(nil)
        allow(Rails.cache).to receive(:write)
        allow(abl).to receive(:slugs_by_page_uuid).and_return(result_data)
      end

      context 'when partial_data is false (normal computation)' do
        before do
          allow(abl).to receive(:partial_data).and_return(false)
        end

        it 'computes the value, caches without expiration, and stores in RequestStore' do
          expect(abl).to receive(:slugs_by_page_uuid).and_return(result_data)
          expect(Rails.cache).to receive(:write).with(cache_key, result_data)

          result = Content.slugs_by_page_uuid

          expect(result).to eq(result_data)
          expect(RequestStore.store[:slugs_by_page_uuid]).to eq(result_data)
        end
      end

      context 'when partial_data is true (failure during computation)' do
        before do
          allow(abl).to receive(:partial_data).and_return(true)
        end

        it 'computes the value, caches with 30 minute expiration, and stores in RequestStore' do
          expect(abl).to receive(:slugs_by_page_uuid).and_return(result_data)
          expect(Rails.cache).to receive(:write).with(
            cache_key,
            result_data,
            { expires_in: 30.minutes }
          )

          result = Content.slugs_by_page_uuid

          expect(result).to eq(result_data)
          expect(RequestStore.store[:slugs_by_page_uuid]).to eq(result_data)
        end
      end
    end
  end
end
