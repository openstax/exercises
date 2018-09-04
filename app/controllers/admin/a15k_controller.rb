require 'a15k/html_preview'

module Admin
  class A15kController < BaseController

    layout false

    def preview
      @exercise = Exercise.find(params[:id])
    end

  end
end

