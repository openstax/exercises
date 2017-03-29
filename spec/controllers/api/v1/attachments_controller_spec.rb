require "rails_helper"

module Api::V1
  describe AttachmentsController, type: :controller, api: true, version: :v1 do

    let(:application)       { FactoryGirl.create :doorkeeper_application }
    let(:user)              { FactoryGirl.create :user, :agreed_to_terms }
    let(:admin)             { FactoryGirl.create :user, :administrator, :agreed_to_terms }

    let(:user_token)        do
      FactoryGirl.create :doorkeeper_access_token,
                         application: application,
                         resource_owner_id: user.id
    end
    let(:admin_token)       do
      FactoryGirl.create :doorkeeper_access_token,
                         application: application,
                         resource_owner_id: admin.id
    end
    let(:application_token) do
      FactoryGirl.create :doorkeeper_access_token,
                         application: application,
                         resource_owner_id: nil
    end

    let(:exercise)          do
      exercise = FactoryGirl.build(:exercise)
      exercise.publication.authors << FactoryGirl.build(
        :author, user: user, publication: exercise.publication
      )
      exercise.save!
      exercise
    end

    let(:exercise_id)       { "#{exercise.number}@draft" }

    describe "POST create" do

        it 'attaches a file to an exercise' do
            image = ActionDispatch::Http::UploadedFile.new({
              filename: 'test_photo_1.jpg',
              type: 'image/jpeg',
              tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png")
            })
            expect do
              api_post :create, user_token, parameters: { exercise_id: exercise_id, file: image }
            end.to change{ exercise.attachments.count }.by(1)
            expect(response).to have_http_status(:success)
        end

    end

    describe "DELETE destroy" do
      it 'removes the attachment when called' do
        attachment = AttachFile.call(
          attachable: exercise, file: 'spec/fixtures/os_exercises_logo.png'
        ).outputs[:attachment]

        expect do
          api_delete :destroy, user_token, parameters: {
            exercise_id: exercise_id, filename: attachment.read_attribute(:asset)
          }
        end.to change(Attachment, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(exercise.attachments.find_by(id: attachment.id)).to be_nil
      end
    end

  end
end
