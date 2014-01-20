module FlickrPrivacy

  class PhotoFetcher
    MAX_ALLOWED=500

    def next
      last_fetched_raw = FlickrPrivacy.flickr_api.photos.search(
                      user_id: FlickrPrivacy.flickr_id,
                      page: 1,
                      per_page: MAX_ALLOWED)
      result = {}
      last_fetched_raw.each do |photo|
        url = FlickRaw.url_b(photo)
        result[ photo['id'] ] = url
      end
      result
    end

  end
  
end
