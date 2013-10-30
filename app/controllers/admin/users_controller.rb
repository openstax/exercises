module Admin
  class UsersController < BaseController

    def search
      handle_with(Admin::UsersSearch,
                  complete: lambda { render 'search' })
    end

  end
end