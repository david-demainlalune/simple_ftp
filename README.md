# SimpleFtp

this gems wraps Net::FTP and adds two utility methods:

### rmdir!(directory_path)

will remove a directory and its content with no warning.

### put_dir(local_directory, remote_directory = File.basename(local_directory))

copies local_directory to remote_directory.  
remote_directory is not a path but a basename, it will appear in the current remote pwd.  
File transfers will be made in whatever mode the session is set (text or binary see Net::FTP docs).

## Example Usage

I wrote this gem originally to help me deploy a jeckyll site via ftp.  
This becomes quite easy with SimpleFtp

		desc "deploy to ftp"
		task :deploy_ftp do
			SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD) do |ftp|
				ftp.rmdir!(FTP_ROOT_DIR)
				ftp.putdir('_site', FTP_ROOT_DIR)
			end
			puts "ftp deploy complete"
		end

## todo:

refactor and cleanup

write #getdir

## dev Installation

		git clone project
		bundle install
		gem build simple_ftp.gemspec
		gem install ./simple_ftp-x.x.x.gem

## testing

		bundle exec rspec spec

needs a live real world ftp server for integration test. 
server configuration done in. This file must be created (it is ignored by git).

		spec/test_ftp_config.yml

an example config is provided. Be smart and don't use a live production server.


## Installation

Add this line to your application's Gemfile:

    gem 'simple_ftp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_ftp


## license 

MIT, david hodgetts 2013  
read, hack, improve



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request