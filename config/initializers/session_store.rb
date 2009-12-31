# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_myimdb_session',
  :secret      => 'e1b0a970762359b4eb66405ff78ce398979a87aad3cb605fd7e2ae4b95b81def418db84c1052415f5dfd8f787c82906ad9d5c53b13bec1799cd019e375697876'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
