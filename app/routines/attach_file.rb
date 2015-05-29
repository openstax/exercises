class AttachFile

  lev_routine

  protected

  def exec(attachable, path)
    attachment = Attachment.new(asset: File.open(path))

    filename = attachment.asset.filename
    existing_attachment = attachable.attachments.where(asset: filename).first
    if existing_attachment.nil?
      attachable.attachments << attachment
    else
      attachment = existing_attachment
    end

    outputs[:url] = attachment.asset.url
  end
end
