module FlickrPrivacy

  class PhotoDownloader
    require "open-uri"

    attr_reader :uri, :file_path

    def initialize(uri)
      @uri = uri
      @file_path = create_file_path(URI(@uri).path)
    end

    def download
      open(uri) { |f|
        File.open(file_path, "wb") do |file|
          file.puts f.read
        end
      }
      file_path
    end


    private

      def create_file_path(path)
        file_name = File.basename(path)
        FlickrPrivacy.tmp_data_path + file_name
      end
  end

end
