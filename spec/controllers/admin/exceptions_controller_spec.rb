require 'rails_helper'

module Admin
  RSpec.describe ExceptionsController, type: :controller do

    EXCEPTIONS = [[SecurityTransgression],
                  [ActiveRecord::RecordNotFound],
                  [ActionController::RoutingError, '/blah/blah/blah'.inspect],
                  [ActionController::UnknownController],
                  [AbstractController::ActionNotFound],
                  [ActionView::MissingTemplate, [['a', 'b'], 'path',
                                                 ['pre1', 'pre2'],
                                                 'partial', 'details'].inspect],
                  [NotYetImplemented],
                  [IllegalArgument]]

    let(:user)  { FactoryGirl.create(:user, :agreed_to_terms) }
    let(:admin) { FactoryGirl.create(:user, :administrator, :agreed_to_terms) }

    describe 'GET show' do
      context 'for anonymous' do
        it 'returns 403 forbidden' do
          EXCEPTIONS.each do |klass, args|
            xhr :get, :show, id: klass.name, args: args
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'for non-admins' do
        it 'raises SecurityTransgression' do
          controller.sign_in user
          EXCEPTIONS.each do |klass, args|
            expect{ xhr :get, :show, id: klass.name, args: args }.to(
              raise_error(SecurityTransgression)
            )
          end
        end
      end

      context 'for admins' do
        it 'raises the given exception' do
          controller.sign_in admin
          EXCEPTIONS.each do |klass, args|
            expect{ xhr :get, :show, id: klass.name, args: args }.to raise_error(klass)
          end
        end
      end
    end
  end
end
