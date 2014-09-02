module Admin
  class CronController < BaseController

    # POST /cron
    def create
      Ost::Cron::execute_cron_jobs
      flash[:notice] = "Ran cron tasks"
      redirect_to admin_url
    end

  end
end
