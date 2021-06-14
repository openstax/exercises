require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let!(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let!(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  context 'for anonymous' do
    context 'GET /admin/users' do
      it 'redirects to the login page' do
        get admin_users_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'PUT /admin/users/:id/become' do
      it 'redirects to the login page' do
        put become_admin_user_url(admin)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'PATCH /admin/users/:id/delete' do
      it 'redirects to the login page' do
        patch delete_admin_user_url(admin)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'PATCH /admin/users/:id/undelete' do
      before { admin.delete }

      it 'redirects to the login page' do
        patch undelete_admin_user_url(admin)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin/users' do
      it 'raises SecurityTransgression' do
        expect { get admin_users_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'PUT /admin/users/:id/become' do
      it 'raises SecurityTransgression' do
        expect { put become_admin_user_url(admin) }.to raise_error(SecurityTransgression)
        expect(@controller.current_user).to eq user
      end
    end

    context 'PATCH /admin/users/:id/delete' do
      it 'raises SecurityTransgression' do
        expect do
          patch delete_admin_user_url(admin)
        end.to  not_change { admin.reload.is_deleted? }
           .and raise_error(SecurityTransgression)
      end
    end

    context 'PATCH /admin/users/:id/undelete' do
      before { admin.delete }

      it 'raises SecurityTransgression' do
        expect do
          patch undelete_admin_user_url(admin)
        end.to  not_change { admin.reload.is_deleted? }
           .and raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin/users' do
      it 'returns 200 OK with a list of all users' do
        get admin_users_url
        expect(response).to have_http_status(:ok)
        expect(css_select("a[href='#{become_admin_user_url(user)}']")).not_to be_empty
      end
    end

    context 'PUT /admin/users/:id/become' do
      it 'signs in as the user and redirects to /' do
        put become_admin_user_url(user)
        expect(response).to redirect_to(root_url)
        expect(@controller.current_user).to eq user
      end
    end

    context 'PATCH /admin/users/:id/delete' do
      it 'deletes the user and redirects to /admin/users' do
        expect do
          patch delete_admin_user_url(user)
        end.to change { user.reload.is_deleted? }.from(false).to(true)
        expect(response).to redirect_to(admin_users_url)
        follow_redirect!
        expect(css_select("a[href='#{delete_admin_user_url(user)}']")).to be_empty
        expect(css_select("a[href='#{undelete_admin_user_url(user)}']")).not_to be_empty
      end
    end

    context 'PATCH /admin/users/:id/undelete' do
      before { user.delete }

      it 'undeletes the user and redirects to /admin/users' do
        expect do
          patch undelete_admin_user_url(user)
        end.to change { user.reload.is_deleted? }.from(true).to(false)
        expect(response).to redirect_to(admin_users_url)
        follow_redirect!
        expect(css_select("a[href='#{delete_admin_user_url(user)}']")).not_to be_empty
        expect(css_select("a[href='#{undelete_admin_user_url(user)}']")).to be_empty
      end
    end
  end
end
