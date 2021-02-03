class CopyAttachmentsToActiveStorage < ActiveRecord::Migration[6.1]
  # These URLs are public and both staging and prod use the same base at the moment
  ASSET_BASE = 'https://s3-us-west-2.amazonaws.com/openstax-assets/Ss2Xg59OLfjbgarp-prodtutor/exercises/attachments'

  def up
    Exercise.joins(:attachments).preload(:attachments).find_each do |exercise|
      exercise.attachments.each do |attachment|
        filename = attachment.read_attribute :asset
        tempfile = open("#{ASSET_BASE}/#{filename}") rescue next # Asset not found

        exercise.images.attach io: open("#{ASSET_BASE}/#{filename}"), filename: filename
        exercise.save!
      end
    end
  end

  def down
  end
end
