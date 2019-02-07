Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GPLUS_CLIENT_ID'], ENV['GPLUS_CLIENT_SECRET']
end
