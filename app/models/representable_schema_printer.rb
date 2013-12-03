class RepresentableSchemaPrinter
  include ActionView::Helpers::JavaScriptHelper

  def self.escape_js( text )
    @instance ||= self.new
    return @instance.escape_javascript( text )
  end

  def self.json(representer, options={})
    options[:include] ||= [:readable, :writeable]
    options[:indent] ||= '  '

    schema = {
      title: representer.name.gsub(/Representer/,''),
      type: "object",
      properties: {},
      required: []
    }

    representer.representable_attrs.each do |attr|
      schema[:required].push(attr.name) if attr.options[:required]

      next unless [options[:include]].flatten.any?{|inc| attr.send(inc.to_s+"?") || attr.options[:required]}
      
      attr_info = {}
      attr.options.each do |key, value|
        next if [:writeable, :readable, :required].include?(key)
        value = ruby_to_schema_type(value) if key == :type
        next if value.nil?
        attr_info[key] = value
      end
      schema[:properties][attr.name.to_sym] = attr_info
    end
    
    JSON.pretty_generate(schema, {indent: options[:indent]})
  end

  def self.ruby_to_schema_type(ruby_type)
    case ruby_type
    when String
      "string"
    when Integer
      "integer"
    else
      nil
    end
  end

end
