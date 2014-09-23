module Admin
  class CronsController < BaseController

    # PATCH /cron
    def update
      # TODO: run jobs
      flash[:notice] = "Ran cron tasks"
      redirect_to root_url
    end

  end
end
