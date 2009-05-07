# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kreilo_session',
  :secret      => 'd77daabd17fb44f4db551becb6c4c61e5817fa5377fd46526ed2ff2b6ebd9117b0eade8859eab10327cb65818d51bae3d3c7124fe26818ae5aa43f91a28ebced'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
