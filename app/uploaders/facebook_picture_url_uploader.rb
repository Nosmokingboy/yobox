class FacebookPictureUrlUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end

