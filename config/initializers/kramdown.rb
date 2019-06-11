# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

Kramdown::Parser::Kramdown.class_exec do

  def add_link_with_attachments(el, href, title, alt_text = nil, ial = nil)
    if Addressable::URI.parse(href).relative? && @options[:attachable]
      # href is actually a path to a local file for the spreadsheet importer
      outputs = AttachFile.call(attachable: @options[:attachable], file: href).outputs
      href = outputs.large_url || outputs.url
    end

    add_link_without_attachments(el, href, title, alt_text, ial)
  end
  alias_method :add_link_without_attachments, :add_link
  alias_method :add_link, :add_link_with_attachments

  SINGLE_DOLLAR_INLINE_MATH_START = /(?<!\\)(?:\\\\)*\$(.*?)(?<!\\)(?:\\\\)*\$/m
  define_parser(:single_dollar_inline_math, SINGLE_DOLLAR_INLINE_MATH_START)
  def parse_single_dollar_inline_math
    parse_inline_math
  end

  def initialize_with_single_dollar_inline_math(source, options)
    initialize_without_single_dollar_inline_math(source, options)

    @span_parsers.insert(@span_parsers.index(:inline_math) + 1, :single_dollar_inline_math)
  end
  alias_method :initialize_without_single_dollar_inline_math, :initialize
  alias_method :initialize, :initialize_with_single_dollar_inline_math

end

module Kramdown::Converter
  module MathEngine

    # This just wraps the LaTeX in a div or span w/ data-math attr
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
            converter.format_as_block_html('div', {'class' => 'MathJax_Preview'}, preview,
                                           opts[:indent])
          end
        else
          converter.format_as_span_html(preview_as_code ? 'code' : 'span',
                                        {'class' => 'MathJax_Preview'}, preview)
        end
      end

    end

  end

  add_math_engine(:openstax, MathEngine::OpenStax)

end
