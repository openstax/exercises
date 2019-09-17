require 'rails_helper'

RSpec.describe Admin::DelegationsController, type: :request do
  let!(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let!(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  let!(:delegation)         { FactoryBot.create :delegation, can_update: false }
  let(:valid_create_params) do
    {
      delegation: {
        delegator_id: admin.id,
        delegate_id: user.id,
        delegate_type: 'User',
        can_assign_authorship: false,
        can_assign_copyright: false,
        can_read: true,
        can_update: false
      }
    }
  end

  context 'for anonymous' do
    context 'GET /admin/delegations' do
      it 'redirects to the login page' do
        get admin_delegations_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/delegations/new' do
      it 'redirects to the login page' do
        get new_admin_delegation_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'POST /admin/delegations' do
      it 'redirects to the login page' do
        expect { post admin_delegations_url, params: valid_create_params }.not_to(
          change { Delegation.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/delegations/:id/edit' do
      it 'redirects to the login page' do
        get edit_admin_delegation_url(delegation)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/delegations/:id/edit" do
        it 'redirects to the login page' do
          expect do
            send method, admin_delegation_url(delegation),
                 params: { delegation: { can_update: true } }
          end.not_to change { delegation.reload.can_update }
          expect(response).to redirect_to(openstax_accounts.login_url)
        end
      end
    end

    context 'DELETE /admin/delegations/:id' do
      it 'redirects to the login page' do
        expect { delete admin_delegation_url(delegation) }.not_to(
          change { Delegation.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/delegations/users.js' do
      it 'returns 403 Forbidden' do
        get users_admin_delegations_url, xhr: true
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin/delegations' do
      it 'raises SecurityTransgression' do
        expect { get admin_delegations_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/delegations/new' do
      it 'raises SecurityTransgression' do
        expect { get new_admin_delegation_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'POST /admin/delegations' do
      it 'raises SecurityTransgression' do
        expect do
          post admin_delegations_url, params: valid_create_params
        end.to  not_change { Delegation.count }
           .and raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/delegations/edit' do
      it 'raises SecurityTransgression' do
        expect { get edit_admin_delegation_url(delegation) }.to raise_error(SecurityTransgression)
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/delegations/:id/edit" do
        it 'raises SecurityTransgression' do
          expect do
            send method, admin_delegation_url(delegation),
                 params: { delegation: { can_update: true } }
          end.to  not_change { delegation.reload.can_update }
             .and raise_error(SecurityTransgression)
        end
      end
    end

    context 'DELETE /admin/delegations/:id' do
      it 'raises SecurityTransgression' do
        expect do
          delete admin_delegation_url(delegation)
        end.to  not_change { Delegation.count }
           .and raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/delegations/users.js' do
      it 'raises SecurityTransgression' do
        expect { get users_admin_delegations_url, xhr: true }.to raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin/delegations' do
      it 'returns 200 OK with a list of all delegations' do
        get admin_delegations_url
        expect(response).to have_http_status(:ok)
        expect(css_select("a[href='#{edit_admin_delegation_url(delegation)}']")).not_to be_empty
      end
    end

    context 'GET /admin/delegations/new' do
      it 'returns 200 OK with a form to create a new delegation' do
        get new_admin_delegation_url
        expect(response).to have_http_status(:ok)
        expect(css_select("form[action='#{admin_delegations_path}']")).not_to be_empty
        expect(css_select('input[type=submit]')).not_to be_empty
      end
    end

    context 'POST /admin/delegations' do
      it 'creates a new delegation and redirects to /admin/delegations' do
        expect { post admin_delegations_url, params: valid_create_params }.to(
          change { Delegation.count }.by(1)
        )
        delegation = Delegation.order(:created_at).last
        expect(delegation.attributes).to(
          include(valid_create_params[:delegation].deep_stringify_keys)
        )
        expect(response).to redirect_to(admin_delegations_url)
        follow_redirect!
        expect(css_select("a[href='#{edit_admin_delegation_url(delegation)}']")).not_to be_empty
      end
    end

    context 'GET /admin/delegations/edit' do
      it 'returns 200 OK with a form to edit the delegation' do
        get edit_admin_delegation_url(delegation)
        expect(response).to have_http_status(:ok)
        expect(css_select("form[action='#{admin_delegation_path(delegation)}']")).not_to be_empty
        expect(css_select('input[type=submit]')).not_to be_empty
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/delegations/:id/edit" do
        it 'updates the delegation and redirects to /admin/delegations' do
          expect do
            send method, admin_delegation_url(delegation),
                 params: { delegation: { can_update: true } }
          end.to change { delegation.reload.can_update }.from(false).to(true)
          expect(response).to redirect_to(admin_delegations_url)
          follow_redirect!
          expect(css_select("a[href='#{edit_admin_delegation_url(delegation)}']")).not_to be_empty
        end
      end
    end

    context 'DELETE /admin/delegations/:id' do
      it 'deletes the delegation and redirects to /admin/delegations' do
        expect { delete admin_delegation_url(delegation) }.to(
          change { Delegation.count }.by(-1)
        )
        expect { delegation.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to(admin_delegations_url)
        follow_redirect!
        expect(css_select("a[href='#{edit_admin_delegation_url(delegation)}']")).to be_empty
      end
    end

    context 'GET /admin/delegations/users.js' do
      it 'returns 200 OK with the search results' do
        get users_admin_delegations_url, xhr: true
        expect(response).to have_http_status(:ok)
        expect(response.body.strip).to start_with('$("#search-results-list").html(')
        expect(response.body.strip).to end_with(');')
      end
    end
  end
end
