require 'erb'
require 'nokogiri'

module A15k

  class HtmlPreview
    attr_reader :exercise, :html

    def initialize(exercise)
      @exercise = exercise
    end

    def template(file)
      ERB.new(
        Pathname.new(__FILE__).dirname.join(file).read
      ).result(binding)
    end

    def generate
      @html = template('html_preview.html.erb')
      @html << template('mathjax.html.erb') if has_math?
      @html
    end

    def has_math?
      Nokogiri::HTML(html).css('math,[data-math]').any?
    end

  end
end
