require 'spec_helper'

module FlickrPrivacy
  describe PhotosWithPeople do
    before do
      RspecSupport::FlickrTest.prepare_account
      RspecSupport::FlickrTest.upload(file: "faces/1.jpg", title: "photo 1 with face")
      RspecSupport::FlickrTest.upload(file: "no_faces/1.jpg", title: "photo 1 without face")
    end

    describe ".list", 'return the list of your images containing faces' do
      it "should have one item" do
        photos_with_people = PhotosWithPeople.new
        photos_with_people.list.size.should == 1
      end
    end

    after do
      #FlickrTest::clear_account
    end
  end
end
