require 'rails_helper'

RSpec.describe Admin::UsersSearch do
  let(:query)    { 'bob' }
  let(:order_by) { 'created_at DESC' }
  let(:per_page) { 42 }
  let(:page)     { 7 }

  [ [ 'Name', 'name:' ], [ 'Username', 'username:' ], [ 'Other', '' ] ].each do |type, prefix|
    context "type: #{type}" do
      let(:query_with_prefix) { "#{prefix}#{query}" }

      let(:params) do
        {
          search: {
            type: type,
            query: query,
            order_by: order_by,
            per_page: per_page,
            page: page
          }
        }
      end

      it 'calls OpenStax::Accounts::SearchAccounts with the given params' do
        expect_any_instance_of(OpenStax::Accounts::SearchAccounts).to(
          receive(:exec).with query_with_prefix, order_by, per_page, page
        )

        described_class.handle params: params
      end
    end
  end
end
