require 'rails_helper'
require 'a15k/html_preview'

RSpec.describe 'html preview of exercises exported to a15k' do
  let(:exercise) {
    FactoryBot.create :exercise, :published, release_to_a15k: true

  }

  it 'includes mathjax script if exercise has math' do
    ex = exercise
    ex.questions[0].answers[0].content << '<div data-math="foo">hi</div>'
    preview = A15k::HtmlPreview.new(exercise)
    preview.generate
    expect(preview.has_math?).to be true
    expect(preview.html).to include 'MathJax.js'
  end

end
