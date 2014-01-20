module FlickrPrivacy

  class PhotosWithPeople

    def list
      fetcher = PhotoFetcher.new
      fetcher.next
    end
  end

end
