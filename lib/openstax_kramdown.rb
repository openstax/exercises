# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

secrets = Rails.application.secrets
class Kramdown::Parser::Openstax < Kramdown::Parser::Html
  ESCAPED_PARENS_MATH_RE = /(.*?)\\\((.*?)\\\)(.*)/

  def initialize(source, options)
    super
    @s3_client = nil
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(
      region: region,
      credentials: Aws::Credentials.new(
        access_key_id: secrets.s3[:access_key_id],
        secret_access_key: secrets.s3[:secret_access_key]
      )
    )
  end

  def convert_img(el)
    return process_html_element(el, false) if el.attr['src'].blank?

    if @options[:attachable] && !Rails.env.development?
      uri = URI.parse(el.attr['src'])
      contents = Net::HTTP.get(uri)

      region = secrets.s3[:region]

      bucket_name = secrets.s3[:uploads_bucket_name]
      key = "#{secrets.environment_name}/#{Digest::SHA2.new.update(contents).to_s}#{File.extname(uri.path)}"

      s3_client.put_object(
        body: StringIO.new(contents),
        bucket: bucket_name,
        key: key
      )

      file.close!

      el.attr['src'] = "https://s3-#{region}.amazonaws.com/#{bucket_name}/#{key}"

      @options[:attachable].attachments << Attachment.new(asset: el.attr['src'])
    end

    set_basics(el, :img)
    process_children(el)
  end

  def add_text(text, tree = @tree, type = @text_type)
    matches = ESCAPED_PARENS_MATH_RE.match(text)
    return super(text, tree, type) if matches.nil?

    super(matches[1], tree, type)

    last = tree.children.last
    location = (last && last.options[:location] || tree.options[:location])
    math_el = Kramdown::Element.new(:html_element, 'span', { 'data-math' => matches[2] }, location: location)
    tree.children << math_el
    super(matches[2], math_el, :text)

    add_text(matches[3], tree, type)
  end
end
