class AttachFile

  lev_routine

  protected

  def exec(attachable, path)
    attachment = Attachment.new(parent: attachable, asset: File.open(path))

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

    outputs[:url]       = attachment.asset.url
    return unless attachment.asset.is_image?(attachment.asset.file)
    outputs[:embed_url] = attachment.asset.embed.url
    outputs[:thumb_url] = attachment.asset.thumb.url
  end
end
