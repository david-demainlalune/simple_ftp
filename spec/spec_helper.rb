require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'simple_ftp' # and any other gems you need
require 'net/ftp'
require 'fileutils'
require 'securerandom'

require 'yaml'

begin
  puts Dir.pwd
  ftp_config = YAML.load_file(File.join('spec', 'test_ftp_config.yml'))
rescue Exception => e
  puts "problem loading test_ftp_config.yml: #{e.message}"
  puts "integration tests require access to live ftp server"
  puts "access to this server is configured in spec/test_ftp_config.yml"
  exit 1
end

DOMAIN = ftp_config["domain"]
FTP_LOGIN = ftp_config["login"]
FTP_PASSWORD =  ftp_config["password"]
FTP_TEST_DIR = ftp_config["test_directory"]

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