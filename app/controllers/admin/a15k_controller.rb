require 'a15k/html_preview'
require 'a15k/exporter'

module Admin
  class A15kController < BaseController

    layout false

    def preview
      @exercise = Exercise.find(params[:id])
    end

    def format
      @format_data = A15k::Exporter.new.local_format_data
    end

  end
end

