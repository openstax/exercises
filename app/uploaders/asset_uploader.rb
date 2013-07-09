# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :medium do
    process :resize_to_fit => [350, 350]
  end

  version :thumb, :from_version => :medium do
    process :resize_to_fill => [100, 100]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "#{Rails.root}/#{model.attachable_type.to_s.underscore}/assets/#{model.number}"
  end
end
