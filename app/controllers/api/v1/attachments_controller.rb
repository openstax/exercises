module Api::V1
  class AttachmentsController < OpenStax::Api::V1::ApiController

    before_filter :get_exercise_or_create_draft

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
      attachment = AttachFile.call(attachable: @exercise,
                                   file: params[:image].tempfile).outputs[:attachment]
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

    def get_exercise_or_create_draft
      Exercise.transaction do
        @number, @version = params[:exercise_id].split('@')
        draft_requested = @version == 'draft' || @version == 'd'

        # If a draft has been requested, lock the latest published exercise first
        # so we don't create 2 drafts
        published_exercise = Exercise.published.with_id(@number).lock.first \
          if draft_requested

        # Attempt to find existing exercise
        @exercise = Exercise.visible_for(current_api_user).with_id(params[:exercise_id]).first
        return unless @exercise.nil?

        # Exercise not found and either draft not requested or
        # no published_exercise so we can't create a draft
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Exercise with 'uid'=#{params[:exercise_id]}") \
          if published_exercise.nil?

        # Check for permission to create the draft
        OSU::AccessPolicy.require_action_allowed!(
          :new_version, current_api_user, published_exercise
        )

        # Draft requested and published exercise found
        @exercise = published_exercise.new_version
        @exercise.save!
      end
    end

  end
end
