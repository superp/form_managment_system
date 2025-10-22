module AuthenticationHelpers
  def start_new_session_for(user)
    # Create a session for the user
    session = user.sessions.create!(
      user_agent: 'RSpec Test',
      ip_address: '127.0.0.1'
    )

    # Set the session in Current
    Current.session = session

    # Set the session cookie with signed value (simulating what the controller expects)
    # In tests, we need to manually sign the cookie value
    signed_value = Rails.application.message_verifier('signed cookie').generate(session.id)
    cookies[:session_id] = signed_value

    session
  end

  def sign_out
    Current.session = nil
    cookies.delete(:session_id)
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
  config.include AuthenticationHelpers, type: :controller
end
