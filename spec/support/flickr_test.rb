# Helper to upload images on the flickr test account.
module RspecSupport
  module FlickrTest
    require 'flickraw'

    class << self
      FLICKR_SEARCH_LIMIT = 500 # more will require pagination
      PHOTO_DIR = File.dirname(__FILE__) + "/photos/"

      def prepare_account
        raise MissingFlickrTestCredentialsException unless filled_authentication_keys?
        FlickRaw.api_key = FlickrPrivacy.env_api_key
        FlickRaw.shared_secret= FlickrPrivacy.env_api_secret
        oauth = FlickrPrivacy::Oauth.new(:test)
        flickr.access_token = oauth.credentials['token']
        flickr.access_secret = oauth.credentials['secret']

        if existing_photos?
          delete_all_photos
        end
      end

      def upload(params)
        photo_path = PHOTO_DIR + params.fetch(:file)
        flickr.upload_photo photo_path, title: params.fetch(:title)
      end

      private

        def filled_authentication_keys?
          FlickrPrivacy.env_api_key && FlickrPrivacy.env_api_secret
        end

        def existing_photos?
          flickr_id = flickr.test.login['id']
          count = flickr.people.getInfo(user_id: flickr_id)['photos']['count']
          raise TooManyPicturesException if count > FLICKR_SEARCH_LIMIT
          count > 0
        end

        def delete_all_photos
          flickr_id = flickr.test.login['id']
          photos = flickr.photos.search(user_id: flickr_id,
                                        per_page: FLICKR_SEARCH_LIMIT)
          photos.each do |photo|
            flickr.photos.delete(photo_id: photo['id'])
          end
        end

    end

    class MissingFlickrTestCredentialsException < Exception
      def message
        "You must provide test API credentials in FLICKR_PRIVACY_API_KEY and FLICKR_PRIVACY_API_SECRET env variables!"
      end
    end

    class TooManyPicturesException < Exception
      def message
        "Looks like the account has more then #{FLICKR_SEARCH_LIMIT} uploaded pictures! Weird since it's a test account!!! Anyway, this script is not ready to delete that many pictures and will terminate now. I suggest to destroy the flickr test account and create a new one or patch the scriptcode to delete with pagination."
      end
    end
  end
end
