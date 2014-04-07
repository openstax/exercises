module Admin
  module Dev
    class UsersController < BaseController

      def create
        handle_with(Admin::Dev::UsersCreate)
      end

      def generate
        handle_with(Admin::Dev::UsersGenerate)
      end

    end
  end
end