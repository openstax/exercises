module Admin
  class ExceptionsController < BaseController

    def show
      exception_class = params[:id].classify.constantize
      raise exception_class.new *params[:args].values
    end

  end
end
