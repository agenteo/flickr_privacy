require "flickr_privacy/version"
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

    def store_test_oauth(token, secret)
      store_oauth(token, secret, 'test')
    end

    def store_oauth(token, secret, filename='live')
      temp_hash = { token: token, secret: secret }
      file_path = File.dirname(__FILE__) + "/../oauth/#{filename}.json"
      File.open(file_path,"w") do |f|
        f.write( JSON.pretty_generate(temp_hash) )
      end
    end
    alias_method :store_live_oauth, :store_oauth

    def test_oauth
      oauth('test')
    end

    def oauth(filename='live')
      file_path = File.dirname(__FILE__) + "/../oauth/#{filename}.json"
      JSON.parse( IO.read(file_path) )
    end

  end
end
