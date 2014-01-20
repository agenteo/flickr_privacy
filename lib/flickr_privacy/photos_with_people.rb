module FlickrPrivacy

  class PhotosWithPeople

    def list
      fetcher = PhotoFetcher.new
      photos = fetcher.next
      photos.each do |photo_id, photo_url|
        photo_downloader = PhotoDownloader.new(photo_url)
        file_path = photo_downloader.download
      end
    end
  end

end
