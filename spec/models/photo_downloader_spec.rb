require 'spec_helper'

module FlickrPrivacy

  describe PhotoDownloader do
    let(:file_name) { '300.jpg' }
    let(:photo_url) { "http://placehold.it/#{file_name}" }
    let(:expected_file) { FlickrPrivacy.tmp_data_path + file_name }

    before { File.delete(expected_file) rescue nil }
    after { File.delete(expected_file) rescue nil }

    it "should download the photo in the temporary folder" do
      VCR.turned_off do
        WebMock.allow_net_connect!
        photo_downloader = PhotoDownloader.new(photo_url)
        expect { photo_downloader.download }.to change { File.exist?(expected_file) }.from(false).to(true)
      end
    end

    it "should return the photo pat" do
      VCR.turned_off do
        WebMock.allow_net_connect!
        photo_downloader = PhotoDownloader.new(photo_url)
        photo_downloader.download.should == expected_file
      end
    end
    
  end
end
