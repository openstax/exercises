class CopyAttachmentsToActiveStorage < ActiveRecord::Migration[6.1]
  # These URLs are public and both staging and prod use the same base at the moment
  ASSET_BASE = 'http://s3-us-west-2.amazonaws.com/openstax-assets/Ss2Xg59OLfjbgarp-prodtutor/exercises/attachments'

  disable_ddl_transaction!

  def up
    Exercise.joins(:attachments).preload(:attachments).find_each(batch_size: 100) do |exercise|
      next unless exercise.images.empty?

      exercise.attachments.each do |attachment|
        filename = attachment.read_attribute :asset

        blob = ActiveStorage::Blob.find_by filename: filename

        if blob.nil?
          tempfile = open("#{ASSET_BASE}/#{filename}") rescue next # HTTP errors etc

          exercise.images.attach io: tempfile, filename: filename
        else
          exercise.images.attach blob
        end
      end

      exercise.save!
    end
  end

  def down
  end
end
