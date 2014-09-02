module Admin
  class ExceptionsController < BaseController

    def create
      exception_class = params[:exception_class].classify.constantize
      raise exception_class.new params[:exception_arguments]
    end

  end
end
