namespace :flickr_privacy do
  task :foo do
    puts 'bar'
  end

  desc "Run this to generate a flickr authentication token"
  task :get_flickr_authentication_token do
    puts "hello world"

    FlickRaw.api_key = FlickrPrivacy::env_api_key
    FlickRaw.shared_secret = FlickrPrivacy::env_api_secret

    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

    puts "Open this url in your process to complete the authication process : #{auth_url}"
    puts "Copy here the number given when you complete the process."
    verify = gets.strip

    begin
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
      login = flickr.test.login
      puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
  end
end
