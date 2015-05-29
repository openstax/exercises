# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
Kramdown::Parser::Kramdown.class_exec do

  def add_link(el, href, title, alt_text = nil)
    href = AttachFile.call(@options[:attachable], href).outputs.url \
      if Addressable::URI.parse(href).relative? && @options[:attachable]

    super(el, href, title, alt_text)
  end

end
