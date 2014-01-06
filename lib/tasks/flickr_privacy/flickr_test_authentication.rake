require 'flickraw'
require_relative '../../flickr_privacy'

namespace :flickr_privacy do
  desc "Run this to generate a flickr authentication token"
  task :get_flickr_authentication_token, :env do |t, args|
    args.with_defaults(:env => 'test')

    FlickRaw.api_key = FlickrPrivacy.env_api_key
    FlickRaw.shared_secret = FlickrPrivacy.env_api_secret

    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

    puts "Open this url in your process to complete the authication process : #{auth_url}"
    puts "Copy here the number given when you complete the process."
    verify = STDIN.gets.chomp

    begin
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
      login = flickr.test.login
      if args[:env] != 'test'
        FlickrPrivacy.store_oauth(flickr.access_token, flickr.access_secret)
        puts "stored in oauth/live.json"
      else
        FlickrPrivacy.store_test_oauth(flickr.access_token, flickr.access_secret)
        puts "stored in oauth/test.json"
      end
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
  end
end
