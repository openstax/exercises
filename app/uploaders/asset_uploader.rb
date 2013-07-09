# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process :resize_to_limit => [100, 150]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "#{Rails.root}/#{model.attachable_type.to_s.underscore}/assets/#{model.number}"
  end
end
