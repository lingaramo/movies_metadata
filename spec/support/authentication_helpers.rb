# frozen_string_literal: true

module AuthenticationHelpers
  def authentication_headers_for(user)
    user.create_new_auth_token
  end
end
