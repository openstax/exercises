class AssetUploader < CarrierWave::Uploader::Base
  ALLOWED_EXTENSIONS = %w(jpg jpeg gif png svg pdf)
  IMAGE_EXTENSIONS = %w(jpg jpeg gif png svg)

  include CarrierWave::MiniMagick

  version :embed, if: :is_image? do
    process :resize_to_limit => [720, 1080]
  end

  version :thumb, if: :is_image? do
    process :resize_to_fit => [100, 100]
  end

  def is_image?(ff = file)
    IMAGE_EXTENSIONS.include? ff.extension
  end

  def extension_white_list
    ALLOWED_EXTENSIONS
  end

  def content_hash
    Digest::SHA2.new.update(read).to_s
  end

  def cache_dir
    Rails.root.join 'tmp/attachments'
  end

  def store_dir
    'attachments'
  end

  def filename
    return if original_filename.blank?

    # Reuse hashed filename for other versions of the same file
    return model.read_attribute(mounted_as) unless version_name.blank?

    # Don't try to hash uncached files
    return super unless cached?

    "#{content_hash}.#{file.extension}"
  end
end
