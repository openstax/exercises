# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

Kramdown::Parser::Kramdown.class_exec do

  def add_link_with_attachments(el, href, title, alt_text = nil)
    href = AttachFile.call(@options[:attachable], href).outputs.url \
      if Addressable::URI.parse(href).relative? && @options[:attachable]

    add_link_without_attachments(el, href, title, alt_text)
  end
  alias_method_chain :add_link, :attachments

end
