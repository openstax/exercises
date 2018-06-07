require 'erb'

module Exercises

  class HtmlPreview
    attr_reader :exercise

    def initialize(exercise)
      @exercise = exercise
    end

    def generate
      template = Pathname.new(__FILE__).dirname.join('html_preview.html.erb')
      ERB.new(template.read).result(binding)
    end

    def nl2br(text)
      text.gsub("\n", '<br>')
    end
  end
end
