# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

Kramdown::Parser::Kramdown.class_exec do

  def add_link_with_attachments(el, href, title, alt_text = nil)
    if Addressable::URI.parse(href).relative? && @options[:attachable]
      outputs = AttachFile.call(@options[:attachable], href).outputs
      href = outputs.large_url || outputs.url
    end

    add_link_without_attachments(el, href, title, alt_text)
  end
  alias_method_chain :add_link, :attachments

  SINGLE_DOLLAR_INLINE_MATH_START = /(?<!\\)(?:\\\\)*\$(.*?)(?<!\\)(?:\\\\)*\$/m
  define_parser(:single_dollar_inline_math, SINGLE_DOLLAR_INLINE_MATH_START)
  def parse_single_dollar_inline_math
    parse_inline_math
  end

  def initialize_with_single_dollar_inline_math(source, options)
    initialize_without_single_dollar_inline_math(source, options)

    @span_parsers.insert(@span_parsers.index(:inline_math) + 1, :single_dollar_inline_math)
  end
  alias_method_chain :initialize, :single_dollar_inline_math

end

Kramdown::Converter::MathEngine::Mathjax.class_exec do

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

end
