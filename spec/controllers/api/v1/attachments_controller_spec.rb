require "rails_helper"

module Api::V1
  describe AttachmentsController, type: :controller, api: true, version: :v1 do

    let(:application) { FactoryGirl.create :doorkeeper_application }
    let(:user)        { FactoryGirl.create :user, :agreed_to_terms }
    let(:admin)       { FactoryGirl.create :user, :administrator, :agreed_to_terms }

    let(:user_token)        { FactoryGirl.create :doorkeeper_access_token,
                                                  application: application,
                                                  resource_owner_id: user.id }
    let(:admin_token)       { FactoryGirl.create :doorkeeper_access_token,
                                                  application: application,
                                                  resource_owner_id: admin.id }
    let(:application_token) { FactoryGirl.create :doorkeeper_access_token,
                                                  application: application,
                                                  resource_owner_id: nil }

    let(:exercise) {
            exercise = FactoryGirl.build(:exercise)
            exercise.publication.authors << FactoryGirl.build(
              :author, user: user, publication: exercise.publication
            )
            exercise.save!
            exercise
    }

    let (:exercise_id){ "#{exercise.number}@draft" }

    describe "POST create" do

        it 'attaches a file to an exercise' do
            image = ActionDispatch::Http::UploadedFile.new({
              :filename => 'test_photo_1.jpg',
              :type => 'image/jpeg',
              :tempfile => File.new("#{Rails.root}/spec/fixtures/rails.png")
            })
            expect {
                api_post :create, user_token, parameters: {
                           exercise_id: exercise_id, image: image
                         }
            }.to(
                change{ exercise.attachments.count }.by(1)
            )
            expect(response).to have_http_status(:success)
        end

    end

    describe "DELETE destroy" do
      it 'removes the attachment when called' do
        attachment = AttachFile.call(
          attachable: exercise, file: 'spec/fixtures/os_exercises_logo.png'
        ).outputs[:attachment]

        expect{ api_delete :destroy, user_token,
                           parameters: { exercise_id: exercise_id, id: attachment.id }
        }.to change(Attachment, :count).by(-1)

        expect(response).to have_http_status(:success)
        expect(exercise.attachments.find_by_id(attachment.id)).to be_nil
      end
    end

  end
end
