# Helper to upload images on the flickr test account.
module RspecSupport
  module FlickrTest
    require 'flickraw'

    class << self
      FLICKR_SEARCH_LIMIT = 500 # more will require pagination
      PHOTO_DIR = File.dirname(__FILE__) + "/photos/"

      def prepare_account
        FlickrPrivacy.initialize_flickr_api_credentials

        if existing_photos?
          delete_all_photos
        end
      end

      def upload(params)
        photo_path = PHOTO_DIR + params.fetch(:file)
        FlickrPrivacy.flickr_api.upload_photo photo_path, title: params.fetch(:title)
      end

      def clear_account
        delete_all_photos
      end

      private

        def existing_photos?
          flickr_id = FlickrPrivacy.flickr_id
          count = FlickrPrivacy.flickr_api.people.getInfo(user_id: flickr_id)['photos']['count']
          raise TooManyPicturesException if count > FLICKR_SEARCH_LIMIT
          count > 0
        end

        def delete_all_photos
          flickr_id = FlickrPrivacy.flickr_id
          photos = FlickrPrivacy.flickr_api.photos.search(user_id: flickr_id,
                                        per_page: FLICKR_SEARCH_LIMIT)
          photos.each do |photo|
            FlickrPrivacy.flickr_api.photos.delete(photo_id: photo['id'])
          end
        end

    end


    class TooManyPicturesException < Exception
      def message
        "Looks like the account has more then #{FLICKR_SEARCH_LIMIT} uploaded pictures! Weird since it's a test account!!! Anyway, this script is not ready to delete that many pictures and will terminate now. I suggest to destroy the flickr test account and create a new one or patch the scriptcode to delete with pagination."
      end
    end
  end
end
