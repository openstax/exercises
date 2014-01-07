require 'ose_markup'

class TransformMarkup

  lev_routine transaction: :no_transaction

protected

  def exec(markup, options={})

    options[:format] ||= 'html'
    
    if markup != ActionController::Base.helpers.strip_tags(markup)
      fatal_error(
        code: :markup_cannot_contain_html,
        data: markup,
        message: 'Markup cannot contain HTML'
      ) 
    end

    parser = OseParser.new
    
    transformer = case options[:format]
    when 'html'
      OseHtmlTransformer.new
    else
      raise IllegalArgument, "'#{format}' is not a recognized transformed output format"
    end

    begin
      tree = parser.parse(markup)
      transformed_tree = transformer.apply(tree, {:attachable => options[:attachable]})
      outputs[:output] = transformed_tree.force_encoding("UTF-8")
    rescue Parslet::ParseFailed => error
      fatal_error(
        code: :markup_formatting_error, 
        data: markup,
        message: "Markup error: #{error.cause.ascii_tree}"
      )
    end

  end


end