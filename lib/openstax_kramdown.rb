require 'addressable/uri'

class Kramdown::Parser::Openstax < Kramdown::Parser::Html
  ESCAPED_PARENS_MATH_RE = /(.*?)\\\((.*?)\\\)(.*)/

  def secrets
    @secrets ||= Rails.application.secrets
  end

  def s3_secrets
    @s3_secrets ||= secrets.aws[:s3]
  end

  def region
    @region ||= s3_secrets[:region]
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(region: region)
  end

  def add_text(text, tree = @tree, type = @text_type)
    matches = ESCAPED_PARENS_MATH_RE.match(text)
    return super(text, tree, type) if matches.nil?

    super(matches[1], tree, type)

    math = matches[2].strip
    last = tree.children.last
    location = (last && last.options[:location] || tree.options[:location])
    math_el = Kramdown::Element.new(:html_element, 'span', { 'data-math' => math }, location: location)
    tree.children << math_el
    super(math, math_el, :text)

    add_text(matches[3], tree, type)
  end

  def handle_html_start_tag(line, &block)
    super(line, &block).tap do
      next if Rails.env.development? || !@options[:attachable]
      last_el = @tree.children.last
      next unless last_el.type == :html_element && last_el.value == 'img' && last_el.attr['src']

      uri = URI.parse(ActionController::Base.helpers.strip_tags(last_el.attr['src'].strip))
      response = Net::HTTP.get_response(uri)
      body = response.body

      bucket_name = s3_secrets[:uploads_bucket_name]
      key = "#{secrets.environment_name}/#{Digest::SHA2.new.update(body).to_s}#{File.extname(uri.path)}"

      s3_client.put_object(
        body: StringIO.new(body),
        bucket: bucket_name,
        content_type: response['content-type'] || 'application/octet-stream',
        key: key
      )

      last_el.attr['src'] = "https://s3.#{region}.amazonaws.com/#{bucket_name}/#{key}"

      next if @options[:attachable].attachments.any? { |attachment| attachment.asset == last_el.attr['src'] }

      @options[:attachable].attachments << Attachment.new(asset: last_el.attr['src'])
    end
  end
end
