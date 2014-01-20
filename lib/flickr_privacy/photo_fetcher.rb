module FlickrPrivacy

  class PhotoFetcher
    MAX_ALLOWED=500

    def next
      last_fetched_raw = FlickrPrivacy.flickr_api.photos.search(
                      user_id: FlickrPrivacy.flickr_id,
                      page: 1,
                      per_page: MAX_ALLOWED)
      last_fetched_raw.map do |photo|
        url = FlickRaw.url_photopage(photo)
        { photo['id'] => url }
      end
    end

  end
  
end
