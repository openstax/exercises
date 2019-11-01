require 'rails_helper'

RSpec.describe Admin::PublicationsController, type: :request do
  before(:all) do
    DatabaseCleaner.start

    @user = FactoryBot.create :user, :agreed_to_terms
    @admin = FactoryBot.create :user, :administrator, :agreed_to_terms

    @exercise = FactoryBot.create :exercise
  end
  after(:all)  { DatabaseCleaner.clean }

  let(:valid_publications_search_params) { { query: "id:#{@exercise.id}" } }

  let(:update_params) do
    valid_publications_search_params.merge collaborator_id: @user.id, collaborator_type: 'Both'
  end
  let(:valid_add_params)    { update_params.merge collaborator_action: 'Add' }
  let(:valid_remove_params) { update_params.merge collaborator_action: 'Remove' }

  let(:valid_collaborators_search_params) { { collaborators_query: @user.username } }

  context 'for anonymous' do
    context 'GET /admin/publications' do
      it 'redirects to the login page' do
        get admin_publications_url, params: valid_publications_search_params
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'PATCH /admin/publications' do
      it 'redirects to the login page' do
        expect do
          patch admin_publications_url, params: valid_add_params
        end.to  not_change { Author.count }
           .and not_change { CopyrightHolder.count }
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/publications/collaborators.js' do
      it 'returns 403 Forbidden' do
        get collaborators_admin_publications_url, xhr: true,
                                                  params: valid_collaborators_search_params
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in @user }

    context 'GET /admin/publications' do
      it 'raises SecurityTransgression' do
        expect do
          get admin_publications_url, params: valid_publications_search_params
        end.to raise_error(SecurityTransgression)
      end
    end

    context 'PATCH /admin/publications' do
      it 'raises SecurityTransgression' do
        expect do
          patch admin_publications_url, params: valid_add_params
        end.to  not_change { Author.count }
           .and not_change { CopyrightHolder.count }
           .and raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/publications/collaborators.js' do
      it 'raises SecurityTransgression' do
        expect do
          get collaborators_admin_publications_url, xhr: true,
                                                    params: valid_collaborators_search_params
        end.to raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in @admin }

    context 'GET /admin/publications' do
      it 'returns 200 OK with no search results' do
        get admin_publications_url
        expect(response).to have_http_status(:ok)
        expect(css_select('#publication-search-results td')).to be_empty
      end

      it 'returns 200 OK with some search results' do
        get admin_publications_url, params: valid_publications_search_params
        expect(response).to have_http_status(:ok)
        expect(css_select('#publication-search-results td')).not_to be_empty
      end
    end

    context 'PATCH /admin/publications' do
      context 'Add' do
        let(:params) { valid_add_params }

        it 'adds the author and copyright holder and redirects to /admin/publications' do
          expect do
            patch admin_publications_url, params: params
          end.to  change { Author.count }.by(1)
             .and change { CopyrightHolder.count }.by(1)
          expect(response).to redirect_to(
            admin_publications_url(
              valid_publications_search_params.merge(per_page: 20, page: 1, type: 'Exercise')
            )
          )

          expect(@exercise.reload.authors.map(&:user)).to include @user
          expect(@exercise.copyright_holders.map(&:user)).to include @user
        end
      end

      context 'Remove' do
        before(:all) do
          DatabaseCleaner.start

          FactoryBot.create :author, user: @user, publication: @exercise.publication
          FactoryBot.create :copyright_holder, user: @user, publication: @exercise.publication
          @exercise.publication.reload
          FactoryBot.create :author, publication: @exercise.publication
          FactoryBot.create :copyright_holder, publication: @exercise.publication
        end
        after(:all)  { DatabaseCleaner.clean }

        let(:params) { valid_remove_params }

        it 'removes the author and copyright holder and redirects to /admin/publications' do
          expect do
            patch admin_publications_url, params: params
          end.to  change { Author.count }.by(-1)
             .and change { CopyrightHolder.count }.by(-1)
          expect(response).to redirect_to(
            admin_publications_url(
              valid_publications_search_params.merge(per_page: 20, page: 1, type: 'Exercise')
            )
          )

          expect(@exercise.reload.authors.map(&:user)).not_to include @user
          expect(@exercise.copyright_holders.map(&:user)).not_to include @user
        end
      end
    end

    context 'GET /admin/publications/collaborators.js' do
      it 'returns 200 OK with the search results' do
        get collaborators_admin_publications_url, xhr: true,
                                                  params: valid_collaborators_search_params
        expect(response).to have_http_status(:ok)
        body = response.body.strip
        expect(body).to include('$("#collaborators-search-results").html(')
        expect(body).to include(');')
      end
    end
  end
end
