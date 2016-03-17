class AttachFile

  lev_routine

  protected

  def exec(attachable:, file: nil, url: nil)
    if file.present?
      file = File.open(file)
      attachment = Attachment.new(parent: attachable, asset: file)
    elsif url.present?
      attachment = Attachment.new(parent: attachable, remote_asset_url: url)
    else
      fatal_error(code: :no_path_or_url, message: 'You must specify either a local file or a url')
    end

    filename = attachment.asset.filename
    existing_attachment = attachable.attachments.where(asset: filename).first
    if existing_attachment.nil?
      attachable.attachments << attachment
      attachment.save! unless attachment.persisted?
      Rails.logger.info "New attachment: #{attachment.asset.url}"
    else
      attachment = existing_attachment
      Rails.logger.info "Reused attachment: #{attachment.asset.url}"
    end

    file.close if file.present?

    outputs[:attachment] = attachment
    outputs[:url] = attachment.asset.url
    return unless attachment.asset.is_image?

    outputs[:large_url] = attachment.asset.large.url
    outputs[:medium_url] = attachment.asset.medium.url
    outputs[:small_url] = attachment.asset.small.url
  end
end
