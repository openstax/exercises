# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

secrets = Rails.application.secrets
Kramdown::Parser::Kramdown.class_exec do
  s3_client = nil

  def add_link_with_attachments(el, href, title, alt_text = nil, ial = nil)
    return add_link_without_attachments(el, href, title, alt_text, ial) \
      if Rails.env.development? || !@options[:attachable]

    uri = URI.parse(href)
    contents = Net::HTTP.get(uri)

    region = secrets.s3[:region]

    s3_client ||= Aws::S3::Client.new(
      region: region,
      credentials: Aws::Credentials.new(
        access_key_id: secrets.s3[:access_key_id],
        secret_access_key: secrets.s3[:secret_access_key]
      )
    )

    bucket_name = secrets.s3[:uploads_bucket_name]
    key = "#{secrets.environment_name}/#{Digest::SHA2.new.update(contents).to_s}#{File.extname(uri.path)}"

    s3_client.put_object(
      body: StringIO.new(contents),
      bucket: bucket_name,
      key: key
    )

    file.close!

    new_url = "https://s3-#{region}.amazonaws.com/#{bucket_name}/#{key}"

    @options[:attachable].attachments << Attachment.new(asset: new_url)

    add_link_without_attachments(el, new_url, title, alt_text, ial)
  end
  alias_method :add_link_without_attachments, :add_link
  alias_method :add_link, :add_link_with_attachments

  ESCAPED_PARENS_INLINE_MATH_START = /\\\((.*?)\\\)/m
  define_parser(:escaped_parens_inline_math, ESCAPED_PARENS_INLINE_MATH_START)
  def parse_escaped_parens_inline_math
    parse_inline_math
  end

  def initialize_with_escaped_parens_inline_math(source, options)
    initialize_without_escaped_parens_inline_math(source, options)

    @span_parsers.insert(@span_parsers.index(:inline_math) + 1, :escaped_parens_inline_math)
  end
  alias_method :initialize_without_escaped_parens_inline_math, :initialize
  alias_method :initialize, :initialize_with_escaped_parens_inline_math
end

module Kramdown::Converter
  module MathEngine
    # This just wraps the LaTeX in a div or span with data-math attr
    module OpenStax
      def self.call(converter, el, opts)
        type = el.options[:category]
        text = (el.value =~ /<|&/ ? "% <![CDATA[\n#{el.value} %]]>" : el.value)
        text.gsub!(/<\/?script>?/, '')

        preview = preview_string(converter, el, opts)

        attr = {:'data-math' => text}
        if type == :block
          preview << converter.format_as_block_html('div', attr, text, opts[:indent])
        else
          preview << converter.format_as_span_html('span', attr, text)
        end
      end

      # Copied from MathJax math_engine
      def self.preview_string(converter, el, opts)
        preview = converter.options[:math_engine_opts][:preview]
        return '' unless preview

        preview = (preview == true ? converter.escape_html(el.value) : preview.to_s)

        preview_as_code = converter.options[:math_engine_opts][:preview_as_code]

        if el.options[:category] == :block
          if preview_as_code
            converter.format_as_block_html('pre', {'class' => 'MathJax_Preview'},
                                           converter.format_as_span_html('code', {}, preview),
                                           opts[:indent])
          else
            converter.format_as_block_html('div', {'class' => 'MathJax_Preview'}, preview, opts[:indent])
          end
        else
          converter.format_as_span_html(preview_as_code ? 'code' : 'span', {'class' => 'MathJax_Preview'}, preview)
        end
      end
    end
  end

  add_math_engine(:openstax, MathEngine::OpenStax)
end
