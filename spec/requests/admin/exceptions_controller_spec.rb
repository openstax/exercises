require 'rails_helper'

RSpec.describe Admin::ExceptionsController, type: :request do
  EXCEPTIONS = [[SecurityTransgression],
                [ActiveRecord::RecordNotFound],
                [ActionController::RoutingError, '/blah/blah/blah'.inspect],
                [AbstractController::ActionNotFound],
                [ActionView::MissingTemplate, [['a', 'b'], 'path',
                                               ['pre1', 'pre2'],
                                               'partial', 'details'].inspect],
                [NotYetImplemented],
                [IllegalArgument]]

  let(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  context 'for anonymous' do
    context 'GET /admin/exceptions/:id' do
      it 'returns 403 forbidden' do
        EXCEPTIONS.each do |klass, args|
          get admin_exception_url(klass.name, args: args), xhr: true
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin/exceptions/:id' do
      it 'raises SecurityTransgression' do
        EXCEPTIONS.each do |klass, args|
          expect { get admin_exception_url(klass.name, args: args), xhr: true }.to(
            raise_error(SecurityTransgression)
          )
        end
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin/exceptions/:id' do
      it 'raises the given exception' do
        EXCEPTIONS.each do |klass, args|
          expect { get admin_exception_url(klass.name, args: args), xhr: true }.to(
            raise_error(klass)
          )
        end
      end
    end
  end
end
