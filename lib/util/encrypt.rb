require 'base64'
module Util
  class Encrypt
    def self.encrypt(value)
      Base64.encode64(Encryptor.encrypt(value,:key => self.get_key))
    end

    def self.decrypt(value)
      Encryptor.decrypt(Base64.decode64(value),:key => get_key)
    end

    private
    def self.get_key
      Base64.decode64(File.read("#{Rails.root}/config/.dbpass"))
    end
  end
end
