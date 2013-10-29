# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'parslet'

class OseParser < Parslet::Parser
  def parse(str)
    # Always make sure we have one 'paragraph'
    super(str.strip + "\n\n")
  end

  rule(:space) { str(' ') }
  rule(:spaces) { space.repeat }

  rule(:cr) { str("\r") }
  rule(:lf) { str("\n") }
  rule(:eol) { cr >> lf | lf }

  rule(:filename) { match['a-zA-Z0-9_\.\-\(\) '].repeat(1) }

  rule(:image_tag) { str("{img:") }
  rule(:image) {  (image_tag >> filename.as(:filename) >> str("}")).as(:image) }

  rule(:math_inline_tag) { str("$") }
  rule(:math_display_tag) { str("$$") }
  rule(:math) {
    (math_inline_tag >> (math_inline_tag.absent? >> any).repeat(1) >> math_inline_tag |
    math_display_tag >> (math_display_tag.absent? >> any).repeat(1) >> math_display_tag).as(:math)
  }

  rule(:bold_tag) { str("!!") }
  rule(:bold) { bold_tag >> content.as(:bold) >> bold_tag }
    
  rule(:italic_tag) { str("''") }
  rule(:italic) { italic_tag >> content.as(:italic) >> italic_tag }
  
  rule(:underline_tag) {str("__") }
  rule(:underline) {underline_tag >> content.as(:underline) >> underline_tag }

  rule(:bullet_tag) { str("*") }
  rule(:bulleted_item) { bullet_tag >> spaces >> content.as(:bulleted_item) }
  rule(:bulleted_list) { (bulleted_item >> eol).repeat(1).as(:bulleted_list) }

  rule(:number_tag) { str("#") }
  rule(:numbered_item) { number_tag >> spaces >> content.as(:numbered_item) }
  rule(:numbered_list) { (numbered_item >> eol).repeat(1).as(:numbered_list) }

  rule(:text) { (
                  ( # Escape characters
                    str("\\$") | str("\\*") | str("\\#")
                  ) | (
                    image_tag.absent? >>
                    math_inline_tag.absent? >>
                    math_display_tag.absent? >>
                    bold_tag.absent? >>
                    italic_tag.absent? >>
                    underline_tag.absent? >>
                    bullet_tag.absent? >>
                    number_tag.absent? >>
                    eol.absent? >>
                    any
                  )
                ).repeat(1).as(:text) }

  rule(:content) { (image | math | bold | italic | underline | text).repeat(1) }
  rule(:line) { (content >> eol).as(:line) }

  rule(:paragraph) { ((line | bulleted_list | numbered_list).repeat(1) >> spaces >> eol).as(:paragraph) }
  rule(:paragraphs) { paragraph.repeat.as(:paragraphs) }

  root(:paragraphs)
end

class OseHtmlTransformer < Parslet::Transform
  def self.make_image_tag(attachable, image_name)
    attachment = attachable.get_attachment(image_name) if attachable.respond_to?(:get_attachment)

    return "<span class = 'undefined_variable' title='No image with this name could be found!'>#{image_name}</span>" \
      if (attachment.nil? || !attachment.asset.is_image?)
    
    "<img src=\"#{attachment.asset.medium.url}\" alt=\"#{attachment.alt}\">" + \
      (attachment.caption.blank? ? "" : "<p>#{attachment.caption}</p>")
  end

  rule(:filename => simple(:filename)) { "#{filename}" }
  rule(:image => simple(:filename)) { |dictionary| "<center>#{make_image_tag(dictionary[:attachable], dictionary[:filename])}</center>" }

  rule(:math => simple(:text)) { "#{text}"}

  rule(:bold => sequence(:items)) { "<b>#{items.join(' ')}</b>"}
  rule(:italic => sequence(:items)) { "<i>#{items.join(' ')}</i>"}
  rule(:underline => sequence(:items)) { "<u>#{items.join(' ')}</u>"}

  rule(:bulleted_item => sequence(:items)) { "<li>#{items.join}</li>" }
  rule(:bulleted_list => sequence(:items)) { "<ul>#{items.join("\n")}</ul>" }

  rule(:numbered_item => sequence(:items)) { "<li>#{items.join}</li>" }
  rule(:numbered_list => sequence(:items)) { "<ol>#{items.join("\n")}</ol>" }

  rule(:text => simple(:text)) { "#{text}" }

  rule(:line => sequence(:items)) { items.join }

  rule(:paragraph => sequence(:items)) { "<p>#{items.join}</p>" }
  rule(:paragraphs => sequence(:items)) { items.join("\n") }
end
