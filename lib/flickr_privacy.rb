require "flickr_privacy/version"
require "flickr_privacy/oauth"
require "flickr_privacy/photo_fetcher"
require "flickr_privacy/photos_with_people"

module FlickrPrivacy
  API_KEY = 'FLICKR_PRIVACY_API_KEY'
  API_SECRET = 'FLICKR_PRIVACY_API_SECRET'


  class << self

    # A proxy to the not namespaecd flickr
    def flickr_api
      flickr
    end

    def flickr_id
      flickr.test.login['id']
    end

    def env_api_key
      ENV[API_KEY]
    end

    def env_api_secret
      ENV[API_SECRET]
    end

    # TODO: add validation on token/secret presence
    def initialize_flickr_api_credentials
      raise MissingFlickrCredentialsException unless filled_authentication_keys?
      FlickRaw.api_key = env_api_key
      FlickRaw.shared_secret= env_api_secret
      flickr_api.access_token = oauth_test_credentials['token']
      flickr_api.access_secret = oauth_test_credentials['secret']
    end

    def oauth_file_path(filename)
      File.dirname(__FILE__) + "/../oauth/#{filename}.json"
    end

    private

      def oauth_test_credentials
        oauth = FlickrPrivacy::Oauth.new(:test)
        oauth.credentials
      end

      def filled_authentication_keys?
        env_api_key && env_api_secret
      end

  end

  class MissingFlickrCredentialsException < Exception
    def message
      "You must provide test API credentials in FLICKR_PRIVACY_API_KEY and FLICKR_PRIVACY_API_SECRET env variables!"
    end
  end
end
