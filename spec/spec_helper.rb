require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'simple_ftp' # and any other gems you need
require 'net/ftp'
require 'fileutils'
require 'securerandom'

module Helpers

	def generate_test_dir_name
		"_test_#{SecureRandom.hex[0, 6]}"
	end

end


RSpec.configure do |config|
  # some (optional) config here
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

end