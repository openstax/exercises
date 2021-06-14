require 'rails_helper'

RSpec.describe Admin::AdministratorsController, type: :request do
  let!(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let!(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  let(:valid_create_params) { { administrator: { user_id: user.id } } }

  context 'for anonymous' do
    context 'GET /admin/administrators' do
      it 'redirects to the login page' do
        get admin_administrators_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'POST /admin/administrators' do
      it 'redirects to the login page' do
        expect { post admin_administrators_url, params: valid_create_params }.not_to(
          change { Administrator.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'DELETE /admin/administrators/:id' do
      it 'redirects to the login page' do
        expect { delete admin_administrator_url(admin.administrator) }.not_to(
          change { Administrator.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin/administrators' do
      it 'raises SecurityTransgression' do
        expect { get admin_administrators_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'POST /admin/administrators' do
      it 'raises SecurityTransgression' do
        expect { post admin_administrators_url, params: valid_create_params }.to(
          raise_error(SecurityTransgression)
        )
      end
    end

    context 'DELETE /admin/administrators/:id' do
      it 'raises SecurityTransgression' do
        expect { delete admin_administrator_url(admin.administrator) }.to(
          raise_error(SecurityTransgression)
        )
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin/administrators' do
      it 'returns 200 OK' do
        get admin_administrators_url
        expect(response).to have_http_status(:ok)
      end
    end

    context 'POST /admin/administrators' do
      it 'makes the given user an administrator' do
        expect { post admin_administrators_url, params: valid_create_params }.to(
          change { Administrator.count }.by(1)
        )
        expect(response).to redirect_to(admin_administrators_url)
        expect(user.reload.is_administrator?).to eq true
      end
    end

    context 'DELETE /admin/administrators/:id' do
      it 'deletes the given administrator' do
        expect { delete admin_administrator_url(admin.administrator) }.to(
          change { Administrator.count }.by(-1)
        )
        expect(response).to redirect_to(admin_administrators_url)
        expect(admin.reload.is_administrator?).to eq false
      end
    end
  end
end
