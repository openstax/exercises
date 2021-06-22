require 'rails_helper'

RSpec.describe Admin::LicensesController, type: :request do
  let!(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let!(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  let!(:license)            { FactoryBot.create :license, allows_derivatives: false }
  let(:valid_create_params) do
    {
      license: license.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at).merge(
        name: 'Dummy License', title: 'Dummy', url: 'https://www.example.com'
      )
    }
  end

  context 'for anonymous' do
    context 'GET /admin/licenses' do
      it 'redirects to the login page' do
        get admin_licenses_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/licenses/new' do
      it 'redirects to the login page' do
        get new_admin_license_url
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'POST /admin/licenses' do
      it 'redirects to the login page' do
        expect { post admin_licenses_url, params: valid_create_params }.not_to(
          change { License.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/licenses/:id' do
      it 'redirects to the login page' do
        get admin_license_url(license)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    context 'GET /admin/licenses/:id/edit' do
      it 'redirects to the login page' do
        get edit_admin_license_url(license)
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/licenses/:id/edit" do
        it 'redirects to the login page' do
          expect do
            send method, admin_license_url(license),
                 params: { license: { allows_derivatives: true } }
          end.not_to change { license.reload.allows_derivatives }
          expect(response).to redirect_to(openstax_accounts.login_url)
        end
      end
    end

    context 'DELETE /admin/licenses/:id' do
      it 'redirects to the login page' do
        expect { delete admin_license_url(license) }.not_to(
          change { License.count }
        )
        expect(response).to redirect_to(openstax_accounts.login_url)
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /admin/licenses' do
      it 'raises SecurityTransgression' do
        expect { get admin_licenses_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/licenses/new' do
      it 'raises SecurityTransgression' do
        expect { get new_admin_license_url }.to raise_error(SecurityTransgression)
      end
    end

    context 'POST /admin/licenses' do
      it 'raises SecurityTransgression' do
        expect do
          post admin_licenses_url, params: valid_create_params
        end.to  not_change { License.count }
           .and raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/licenses/:id' do
      it 'raises SecurityTransgression' do
        expect { get admin_license_url(license) }.to raise_error(SecurityTransgression)
      end
    end

    context 'GET /admin/licenses/edit' do
      it 'raises SecurityTransgression' do
        expect { get edit_admin_license_url(license) }.to raise_error(SecurityTransgression)
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/licenses/:id/edit" do
        it 'raises SecurityTransgression' do
          expect do
            send method, admin_license_url(license),
                 params: { license: { allows_derivatives: true } }
          end.to  not_change { license.reload.allows_derivatives }
             .and raise_error(SecurityTransgression)
        end
      end
    end

    context 'DELETE /admin/licenses/:id' do
      it 'raises SecurityTransgression' do
        expect do
          delete admin_license_url(license)
        end.to  not_change { License.count }
           .and raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /admin/licenses' do
      it 'returns 200 OK with a list of all licenses' do
        get admin_licenses_url
        expect(response).to have_http_status(:ok)
        expect(css_select("a[href='#{edit_admin_license_url(license)}']")).not_to be_empty
      end
    end

    context 'GET /admin/licenses/new' do
      it 'returns 200 OK with a form to create a new license' do
        get new_admin_license_url
        expect(response).to have_http_status(:ok)
        expect(css_select("form[action='#{admin_licenses_path}']")).not_to be_empty
        expect(css_select('input[type=submit]')).not_to be_empty
      end
    end

    context 'POST /admin/licenses' do
      it 'creates a new license and redirects to /admin/licenses/:id' do
        expect { post admin_licenses_url, params: valid_create_params }.to(
          change { License.count }.by(1)
        )
        license = License.order(:created_at).last
        expect(license.attributes).to(
          include(valid_create_params[:license].deep_stringify_keys)
        )
        expect(response).to redirect_to(admin_license_url(license))
        follow_redirect!
        expect(css_select("a[href='#{edit_admin_license_url(license)}']")).not_to be_empty
      end
    end

    context 'GET /admin/licenses/:id' do
      it 'returns 200 OK with the license' do
        get admin_license_url(license)
        expect(response).to have_http_status(:ok)
        expect(css_select("a[href='#{edit_admin_license_url(license)}']")).not_to be_empty
      end
    end

    context 'GET /admin/licenses/edit' do
      it 'returns 200 OK with a form to edit the license' do
        get edit_admin_license_url(license)
        expect(response).to have_http_status(:ok)
        expect(css_select("form[action='#{admin_license_path(license)}']")).not_to be_empty
        expect(css_select('input[type=submit]')).not_to be_empty
      end
    end

    [ :put, :patch ].each do |method|
      context "#{method.to_s.upcase} /admin/licenses/:id/edit" do
        it 'updates the license and redirects to /admin/licenses/:id' do
          expect do
            send method, admin_license_url(license),
                 params: { license: { allows_derivatives: true } }
          end.to change { license.reload.allows_derivatives }.from(false).to(true)
          expect(response).to redirect_to(admin_license_url(license))
          follow_redirect!
          expect(css_select("a[href='#{edit_admin_license_url(license)}']")).not_to be_empty
        end
      end
    end

    context 'DELETE /admin/licenses/:id' do
      it 'deletes the license and redirects to /admin/licenses' do
        expect { delete admin_license_url(license) }.to(
          change { License.count }.by(-1)
        )
        expect { license.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to(admin_licenses_url)
        follow_redirect!
        expect(css_select("a[href='#{edit_admin_license_url(license)}']")).to be_empty
      end
    end
  end
end
