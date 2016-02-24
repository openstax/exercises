module Api::V1
  class AttachmentsController < OpenStax::Api::V1::ApiController

    before_filter :get_exercise


    ##########
    # create #
    ##########

    api :POST, '/exercises/:exercise_id/attachments', 'Save an image onto an exercise'
    description <<-EOS
      Saves an image asset as an attachment on an Exercise.

      Unlike other API calls, this is accomplished via a multi-part form upload
      with a file part, not as a traditional POST of JSON data

      Requires a single form parameter named "image"

      #{json_schema(Api::V1::AttachmentRepresenter, include: :readable)}
    EOS
    def create
      attachment = AttachFile.call(@exercise, params[:image].tempfile).outputs[:attachment]
      respond_with attachment, represent_with: Api::V1::AttachmentRepresenter, location: nil
    end


    ###########
    # destroy #
    ###########

    api :DELETE, '/exercises/:exercise_id/attachment/:id', 'Deletes the specified Attachment'
    description <<-EOS
      Deletes an attachment belonging to exercise
    EOS
    def destroy
      attachment = @exercise.attachments.find(params[:id])
      standard_destroy(attachment)
    end

    protected

    def get_exercise
      @exercise = Exercise.visible_for(current_api_user).with_uid(params[:exercise_id]).first || \
        raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{params[:exercise_id]}")
    end

  end
end
