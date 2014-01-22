module FlickrPrivacy
  require 'opencv'

  class PhotoAnalizer
    include OpenCV

    def initialize(photo_path)
      @photo_path = photo_path
    end

    def match?
      detector = CvHaarClassifierCascade::load(FlickrPrivacy.haarcascades_path + "haarcascade_frontalface_alt.xml")
      image = IplImage::load(@photo_path)
      !detector.detect_objects(image).empty?
    end

  end

end
