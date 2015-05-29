# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
require 'addressable/uri'

Kramdown::Parser::Kramdown.class_exec do

  def add_link_with_attachments(el, href, title, alt_text = nil)
    if Addressable::URI.parse(href).relative? && @options[:attachable]
      outputs = AttachFile.call(@options[:attachable], href).outputs
      href = outputs.embed_url || outputs.url
    end

    add_link_without_attachments(el, href, title, alt_text)
  end
  alias_method_chain :add_link, :attachments

end
