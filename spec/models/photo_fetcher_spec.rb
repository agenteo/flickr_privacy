require 'spec_helper'

module FlickrPrivacy

  describe PhotoFetcher do

    describe ".next" do
      context "with one photo in the archive" do
        let(:url_regexp) { /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix }
        before do
          VCR.use_cassette('prepare') do
            FlickrPrivacy.initialize_flickr_api_credentials
          end
          VCR.use_cassette('upload') do
            RspecSupport::FlickrTest.upload(file: "faces/1.jpg", title: "photo 1 with face")
          end
        end

        after do
          VCR.use_cassette('clear') do
            RspecSupport::FlickrTest::clear_account
          end
        end

        it "should return an array of photos with one element" do
          VCR.use_cassette('search') do
            fetcher = PhotoFetcher.new
            photos = fetcher.next
            photos.size.should == 1
          end
        end

        it "should return a photo with an URL as value" do
          VCR.use_cassette('search') do
            fetcher = PhotoFetcher.new
            first_photo_url = fetcher.next.first
            first_photo_url =~ url_regexp
          end
        end

      end
    end
  end
  
end
