# Alternative authentication helper that uses mocking instead of cookies
# Use this if you have issues with signed cookies in tests

module AuthenticationHelpersAlternative
  def start_new_session_for(user)
    # Create a session for the user
    session = user.sessions.create!(
      user_agent: 'RSpec Test',
      ip_address: '127.0.0.1'
    )

    # Set the session in Current
    Current.session = session

    # Mock the find_session_by_cookie method to return our session
    # This bypasses the need for actual cookies
    allow_any_instance_of(Authentication).to receive(:find_session_by_cookie).and_return(session)

    session
  end

  def sign_out
    Current.session = nil
    # Reset the mock
    allow_any_instance_of(Authentication).to receive(:find_session_by_cookie).and_call_original
  end
end

# To use this alternative helper, replace the include in rails_helper.rb:
# config.include AuthenticationHelpersAlternative, type: :request
# config.include AuthenticationHelpersAlternative, type: :controller
