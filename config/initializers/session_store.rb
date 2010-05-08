# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_word_timeline_session',
  :secret      => '10bc401dad78ab2dcc2f1bfe375482014803f00ebb90a061634a740dcad76df270dc8dd6f2133bb193bdfe5c17ceb1799b6af4ebbae990a691ad120a4ae119aa'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
