class AttachFile

  lev_routine

  protected

  def exec(attachable, path)
    File.open(path) do |file|
      attachment = Attachment.new(parent: attachable, asset: file)

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

      outputs[:attachment] = attachment
      outputs[:url] = attachment.asset.url
      return unless attachment.asset.is_image?

      outputs[:large_url] = attachment.asset.large.url
      outputs[:medium_url] = attachment.asset.medium.url
      outputs[:small_url] = attachment.asset.small.url
    end
  end
end
