class AttachFile

  lev_routine

  protected

  def exec(attachable:, file: nil, url: nil)
    if file.present?
      file = File.open(file)
      unlink_file = false
    elsif url.present?
      contents = Net::HTTP.get(URI.parse(url))
      file = Tempfile.new('attachment')
      file.binmode
      file.write(contents)
      file.rewind
      unlink_file = true
    else
      fatal_error(code: :no_path_or_url, message: 'You must specify either a local file or a url')
    end

    attachment = Attachment.new(parent: attachable, asset: file)
    existing_attachment = attachable.attachments.find{ |att| att.filename == attachment.filename }
    if existing_attachment.nil?
      # The attachment MUST be saved or else the URL's returned will be wrong (tmp folder)
      attachment.save!
      attachable.attachments.reset
      transfer_errors_from(attachment, {type: :verbatim}, true)
      Rails.logger.info "New attachment: #{attachment.asset.url}"
    else
      attachment = existing_attachment
      Rails.logger.info "Reused attachment: #{attachment.asset.url}"
    end

    unlink_file ? file.close! : file.close

    outputs[:attachment] = attachment
    outputs[:url] = attachment.asset.url
    return unless attachment.asset.is_image?

    outputs[:large_url] = attachment.asset.large.url
    outputs[:medium_url] = attachment.asset.medium.url
    outputs[:small_url] = attachment.asset.small.url
  end
end
