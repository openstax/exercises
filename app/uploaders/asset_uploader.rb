class AssetUploader < CarrierWave::Uploader::Base
  ALLOWED_EXTENSIONS = %w(jpg jpeg gif png svg pdf)

  include CarrierWave::MiniMagick

  before :cache, :check_whitelist_pattern!

  process convert: 'png', if: :is_image?
  process :compress, if: :is_image?

  version :large, if: :is_image? do
    process :resize_to_limit => [720, 1080]
  end

  version :medium, if: :is_image?, from_version: :large do
    process :resize_to_limit => [360, 540]
  end

  version :small, if: :is_image?, from_version: :medium do
    process :resize_to_limit => [180, 270]
  end

  def compress
    manipulate! do |img|
      img.combine_options do |c|
        c.strip
        c.blur '0x0.02'
      end

      img
    end
  end

  def is_image?(ff = file)
    mt = mime_type(ff)

    !mt.nil? && mt.start_with?('image/')
  end

  def check_whitelist_pattern!(file)
    mime = mime_type(file)

    raise(CarrierWave::IntegrityError, "Unknown asset type") if mime.nil?

    raise(CarrierWave::IntegrityError, "#{mime} is an invalid asset type") \
      unless ALLOWED_EXTENSIONS.find { |ext| mime.include?(ext) }
  end

  def mime_type(file)
    mm_file = case file
    when CarrierWave::SanitizedFile
      file.to_file
    when CarrierWave::Storage::Fog::File
      file.read
    else
      open(file)
    end

    MimeMagic.by_magic(mm_file).try!(:type)
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

    is_image? ? "#{content_hash}.png" : "#{content_hash}.pdf"
  end
end
