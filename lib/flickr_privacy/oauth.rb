module FlickrPrivacy

  class Oauth
    attr_reader :mode, :file_path
    MODES = [:live, :test]

    def initialize(mode = :live)
      @mode = mode
      raise InvalidModeException unless valid_mode?

      @file_path = FlickrPrivacy.oauth_file_path(@mode)
    end

    def store(token, secret)
      temp_hash = { token: token, secret: secret }
      File.open(file_path,"w") do |f|
        f.write( JSON.pretty_generate(temp_hash) )
      end
    end

    def credentials
      JSON.parse( IO.read(file_path) )
    end


    private

      def valid_mode?
        MODES.include?(@mode)
      end

      class InvalidModeException < Exception
        def message
          "The only valid modes are :test and :live!!!"
        end
      end
  end

end
