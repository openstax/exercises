class AttachableAsset < ActiveRecord::Base
  attr_accessible :asset_id, :attachable_id, :attachable_type, :description, :local_name
end
