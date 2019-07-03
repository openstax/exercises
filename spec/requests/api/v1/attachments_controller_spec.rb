require "rails_helper"

RSpec.describe Api::V1::AttachmentsController, type: :request, api: true, version: :v1 do

  let(:application)       { FactoryBot.create :doorkeeper_application }
  let(:user)              { FactoryBot.create :user, :agreed_to_terms }
  let(:admin)             { FactoryBot.create :user, :administrator, :agreed_to_terms }

  let(:user_token)        do
    FactoryBot.create :doorkeeper_access_token,
                      application: application,
                      resource_owner_id: user.id
  end
  let(:admin_token)       do
    FactoryBot.create :doorkeeper_access_token,
                      application: application,
                      resource_owner_id: admin.id
  end
  let(:application_token) do
    FactoryBot.create :doorkeeper_access_token,
                      application: application,
                      resource_owner_id: nil
  end

  let(:exercise)          do
    FactoryBot.build(:exercise).tap do |exercise|
      exercise.publication.authors << FactoryBot.build(
        :author, user: user, publication: exercise.publication
      )
      exercise.publication.copyright_holders << FactoryBot.build(
        :copyright_holder, user: user, publication: exercise.publication
      )
      exercise.save!
    end
  end

  let(:exercise_id)       { "#{exercise.number}@draft" }

  context "POST /api/exercises/:exercise_id/attachments" do

    let(:image) do
      Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/rails.png", 'image/jpeg')
    end

    it 'attaches a file to an exercise' do
      expect do
        api_post api_exercise_attachments_url(exercise_id), user_token, params: { file: image }
      end.to change{ exercise.attachments.count }.by(1)
      expect(response).to have_http_status(:created)
    end

    it 'creates a draft if needed' do
      exercise.publication.publish.save!
      expect do
        api_post api_exercise_attachments_url(exercise_id), user_token, params: { file: image }
      end.to change{ exercise.publication_group.reload.latest_version }.from(1).to(2)
      expect(response).to have_http_status(:created)
    end

  end

  context "DELETE /api/exercises/:exercise_id/attachments" do
    it 'removes the attachment when called' do
      attachment = AttachFile.call(
        attachable: exercise, file: 'spec/fixtures/os_exercises_logo.png'
      ).outputs[:attachment]

      expect do
        api_delete api_exercise_attachments_url(exercise_id), user_token,
                   params: { filename: attachment.read_attribute(:asset) }.to_json
      end.to change(Attachment, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(exercise.attachments.find_by(id: attachment.id)).to be_nil
    end
  end

end
