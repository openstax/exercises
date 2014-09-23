class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :medium, :if => :is_image? do
    process :resize_to_fit => [350, 1000]
  end

  version :thumb, :if => :is_image? do
    process :resize_to_fill => [100, 100]
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  def store_dir
    "uploads/#{model.attachable_type.to_s.underscore}/attachments/#{model.number}"
  end

  def is_image?(imgfile = file)
    imgfile.extension != 'pdf'
  end
end
