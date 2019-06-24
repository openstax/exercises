module Admin
  class DelegationsController < BaseController

    respond_to :html

    before_action :set_delegation, only: [ :edit, :update, :destroy ]

    # GET /admin/delegations
    def index
      @delegations = Delegation.all
    end

    # GET /admin/delegations/new
    def new
      @delegation = Delegation.new

      handle_with Admin::UsersSearch
    end

    # POST /admin/delegations
    def create
      @delegation = Delegation.new delegation_params

      if @delegation.save
        redirect_to admin_delegations_path, notice: "Delegation from #{
          @delegation.delegator.name} to #{@delegation.delegate.name} created."
      else
        self.action_name = 'new'
        handle_with Admin::UsersSearch
      end
    end

    # GET /admin/delegations/1/edit
    def edit
      handle_with Admin::UsersSearch
    end

    # PATCH /admin/delegations/1
    def update
      if @delegation.update_attributes(delegation_params)
        redirect_to admin_delegations_path, notice: "Delegation from #{
          @delegation.delegator.name} to #{@delegation.delegate.name} updated."
      else
        self.action_name = 'edit'
        handle_with Admin::UsersSearch
      end
    end

    # DELETE /admin/delegations/1
    def destroy
      @delegation.destroy

      redirect_to admin_delegations_path, notice: "Delegation from #{
        @delegation.delegator.name} to #{@delegation.delegate.name} deleted."
    end

    # GET /admin/delegations/users
    def users
      handle_with Admin::UsersSearch

      respond_to :js
    end

    protected

    def set_delegation
      @delegation = Delegation.find(params[:id])
    end

    def delegation_params
      params.require(:delegation).permit(
        :delegator_id, :delegate_id, :can_read, :can_assign_authorship,
        :can_assign_copyright, :can_update
      )
    end

  end
end
