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
end
