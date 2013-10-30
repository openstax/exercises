module Dev

  class CreateUser
    lev_routine

    uses_routine OpenStax::Connect::Dev::CreateUser,
                 translations: { outputs: {scope: :connect} }
    uses_routine GetOrCreateUserFromConnectUser,
                 translations: { outputs: {type: :verbatim} }

  protected

    def exec(options={})
      run(OpenStax::Connect::Dev::CreateUser, 
          options.slice(:first_name, :last_name, :username, :ensure_no_errors))

      run(GetOrCreateUserFromConnectUser, outputs[[:connect, :user]])
    end
  end

end