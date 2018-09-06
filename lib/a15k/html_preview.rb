require 'erb'

module A15k

  class HtmlPreview
    attr_reader :exercise

    def initialize(exercise)
      @exercise = exercise
    end

    def generate
      template = Pathname.new(__FILE__).dirname.join('html_preview.html.erb')
      ERB.new(template.read).result(binding)
    end

  end
end
