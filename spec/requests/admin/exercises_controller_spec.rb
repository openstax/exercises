require 'rails_helper'

RSpec.describe Admin::ExercisesController, type: :request do
  let(:user)  { FactoryBot.create(:user, :agreed_to_terms) }
  let(:admin) { FactoryBot.create(:user, :administrator, :agreed_to_terms) }

  context 'for anonymous' do
    context 'GET /exercises/invalid' do
      it 'redirects to the login page' do
        get invalid_admin_exercises_url
        expect(response).to redirect_to openstax_accounts.login_url
      end
    end
  end

  context 'for non-admins' do
    before { sign_in user }

    context 'GET /exercises/invalid' do
      it 'raises SecurityTransgression' do
        expect { get invalid_admin_exercises_url }.to raise_error(SecurityTransgression)
      end
    end
  end

  context 'for admins' do
    before { sign_in admin }

    context 'GET /exercises/invalid' do
      let(:no_alt_text_img_content)      { Faker::Lorem.paragraph + '<img src="/example.jpg"/>' }
      let(:invalid_alt_text_img_content) do
        Faker::Lorem.paragraph + '<img src="/example.jpg"/ alt="Hello there">'
      end
      let(:valid_alt_text_img_content)   do
        Faker::Lorem.paragraph + '<img src="/example.jpg"/ alt="A nice plump alt text">'
      end

      let!(:valid_exercises) do
        [
          FactoryBot.create(:exercise, context: valid_alt_text_img_content),
          FactoryBot.create(:exercise, stimulus: valid_alt_text_img_content)
        ]
      end

      context 'without any invalid exercises' do
        it 'displays a message' do
          get invalid_admin_exercises_url
          expect(response).to redirect_to '/'
          expect(flash[:notice]).to eq 'No invalid exercises found'
        end
      end

      context 'with invalid exercises' do
        let!(:invalid_exercises) do
          [
            FactoryBot.create(:exercise, context: no_alt_text_img_content),
            FactoryBot.create(:exercise, stimulus: no_alt_text_img_content),
            FactoryBot.create(:exercise, context: invalid_alt_text_img_content),
            FactoryBot.create(:exercise, stimulus: invalid_alt_text_img_content)
          ]
        end

        it 'redirects to the search page listing all invalid exercises' do
          get invalid_admin_exercises_url
          expect(response).to redirect_to(
            "/search?q=uid:#{invalid_exercises.map(&:uid).join(',')}"
          )
        end
      end
    end
  end
end
