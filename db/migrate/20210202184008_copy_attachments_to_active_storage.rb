class CopyAttachmentsToActiveStorage < ActiveRecord::Migration[6.1]
  # These URLs are public and both staging and prod use the same base at the moment
  ASSET_BASE = 'http://s3-us-west-2.amazonaws.com/openstax-assets/Ss2Xg59OLfjbgarp-prodtutor/exercises/attachments'

  disable_ddl_transaction!

  def up
    Exercise.joins(:attachments).preload(:attachments).find_each do |exercise|
      Exercise.transaction do
        next unless exercise.images.empty?

        exercise.attachments.each do |attachment|
          filename = attachment.read_attribute :asset
          tempfile = open("#{ASSET_BASE}/#{filename}") rescue next # Asset not found etc

          exercise.images.attach io: tempfile, filename: filename
        end

        exercise.save!
      end
    end
  end

  def down
  end
end
