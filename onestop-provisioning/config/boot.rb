require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
# ENV['NLS_LANG'] = 'AMERICAN_AMERICA.UTF8'
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

class GetPass
	require "openssl"
	require "digest"

	def initialize(epass=nil, key=nil)
		@pass = epass
		@key = key
		@en_pass = "S|M>\xFE\xE0h\xFB\xDD\x97\x01 \x9B`\xA9\x19"
		@key_pass = "YhYtR@@!@1hdfgjdhfg@@@1111kkjhgfdjshgf@@@@@@"
	end

	def decrypt_pass
		key = Digest::SHA256.digest(@key_pass) if(@key_pass.kind_of?(String) && 32 != @key_pass.bytesize)
		aes = OpenSSL::Cipher.new('AES-256-CBC')
		aes.decrypt
		aes.key = key
		aes.update(@en_pass) + aes.final
	end

	def encrypt_pass
		key = Digest::SHA256.digest(@key) if(@key.kind_of?(String) && 32 != @key.bytesize)
		aes = OpenSSL::Cipher.new('AES-256-CBC')
		aes.encrypt
		aes.key = key
		aes.update(@pass) + aes.final
	end
end