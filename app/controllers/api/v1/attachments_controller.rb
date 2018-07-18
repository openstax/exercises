module Api::V1
  class AttachmentsController < OpenStax::Api::V1::ApiController

    include Exercises::Finders

    before_filter :find_exercise_or_create_draft, only: [:create]
    before_filter :find_exercise, only: [:destroy]

    ##########
    # create #
    ##########

    api :POST, '/exercises/:exercise_id/attachments', 'Save an image onto an exercise'
    description <<-EOS
      Saves a file asset as an attachment on an Exercise.

      Unlike other API calls, this is accomplished via a multi-part form upload
      with a file part, not as a traditional POST of JSON data

      Requires a single form parameter named "file"

      #{json_schema(Api::V1::AttachmentRepresenter, include: :readable)}
    EOS
    def create
      attachment = AttachFile.call(
        attachable: @exercise, file: params[:file].tempfile
      ).outputs[:attachment]
      respond_with attachment, represent_with: Api::V1::AttachmentRepresenter, location: nil
    end


    ###########
    # destroy #
    ###########

    api :DELETE, '/exercises/:exercise_id/attachments', 'Deletes the specified Attachment'
    description <<-EOS
      Deletes an attachment belonging to an exercise

      Requires a single form parameter named "filename"

      #{json_schema(Api::V1::AttachmentRepresenter, include: :readable)}
    EOS
    def destroy
      attachment = @exercise.attachments.find_by! asset: params[:filename]
      standard_destroy(attachment)
    end

  end
end
