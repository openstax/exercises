# https://www.snip2code.com/Snippet/49311/Monkey-patch-for-Kramdown-to-rewrite-rel
Kramdown::Parser::Kramdown.class_exec do

  def base_url
    'assets/attachments/'
  end

  def add_link(el, href, title, alt_text = nil)
    href = Addressable::URI.join(base_url, href).to_s if Addressable::URI.parse(href).relative?

    super(el, href, title, alt_text)   
  end

end
