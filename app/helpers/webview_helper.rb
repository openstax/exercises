module WebviewHelper

  # Generates data for the FE to read as it boots up
  def client_bootstrap_data
    current_user.is_anonymous? ? '{}' :
      Api::V1::UserBootstrapDataRepresenter.new(current_user).as_json
  end

end
