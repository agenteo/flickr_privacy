require 'spec_helper'

module FlickrPrivacy

  describe PhotoAnalizer do
    let(:photo_dir) { File.dirname(__FILE__) + "/../support/photos/" }

    describe ".match?" do
      context "with a photo with a face" do
        let(:photo_with_face_path) { photo_dir + 'faces/1.jpg' }

        it "should be true" do
          analizer = PhotoAnalizer.new(photo_with_face_path)
          analizer.should be_a_match
        end
      end

      context "with a photo with no recognizible faces" do
        let(:photo_without_face_path) { photo_dir + 'no_faces/1.jpg' }

        it "should be false" do
          analizer = PhotoAnalizer.new(photo_without_face_path)
          analizer.should_not be_a_match
        end
      end
    end

  end

end
