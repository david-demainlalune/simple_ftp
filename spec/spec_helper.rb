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

  def generate_files_and_directories_on_server(ftp, test_dir_name)
    ftp.mkdir(test_dir_name)
    ftp.chdir(test_dir_name)
    ftp.put('spec/test_data/test.txt')

    ftp.mkdir("pipo")
    ftp.chdir("pipo")
    ftp.put('spec/test_data/test.txt', 'test2.txt')
    
    ftp.mkdir("cerises")
    ftp.chdir("cerises")
    ftp.put('spec/test_data/test.txt', 'test3.txt')
    ftp.mkdir('framboises')

    ftp.chdir('..')
    ftp.chdir('..')
    ftp.chdir('..')
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