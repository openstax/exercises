class Asset < ActiveRecord::Base
  attr_accessible :attachment_content_type, :attachment_file_name, :attachment_file_size, :attachment_uploaded_at, :uploader_id
end
