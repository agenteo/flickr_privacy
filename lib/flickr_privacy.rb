require "flickr_privacy/version"
require "flickr_privacy/oauth"
require "flickr_privacy/photos_with_people"

module FlickrPrivacy
  API_KEY = 'FLICKR_PRIVACY_API_KEY'
  API_SECRET = 'FLICKR_PRIVACY_API_SECRET'


  class << self
    def env_api_key
      ENV[API_KEY]
    end

    def env_api_secret
      ENV[API_SECRET]
    end

    def oauth_file_path(filename)
      File.dirname(__FILE__) + "/../oauth/#{filename}.json"
    end

  end
end
