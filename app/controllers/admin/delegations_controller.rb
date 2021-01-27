module Admin
  class DelegationsController < BaseController
    around_action :respond_to_html, except: :users
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
        redirect_to admin_delegations_url, notice: "Delegation from #{
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
      if @delegation.update(delegation_params)
        redirect_to admin_delegations_url, notice: "Delegation from #{
          @delegation.delegator.name} to #{@delegation.delegate.name} updated."
      else
        self.action_name = 'edit'
        handle_with Admin::UsersSearch
      end
    end

    # DELETE /admin/delegations/1
    def destroy
      @delegation.destroy

      redirect_to admin_delegations_url, notice: "Delegation from #{
        @delegation.delegator.name} to #{@delegation.delegate.name} deleted."
    end

    # GET /admin/delegations/users.js
    def users
      respond_to { |format| format.js { handle_with Admin::UsersSearch } }
    end

    protected

    def set_delegation
      @delegation = Delegation.find(params[:id])
    end

    def respond_to_html
      respond_to { |format| format.html { yield } }
    end

    def delegation_params
      params.require(:delegation).permit(
        :delegator_id, :delegate_id, :delegate_type, :can_read,
        :can_assign_authorship, :can_assign_copyright, :can_update
      )
    end
  end
end
