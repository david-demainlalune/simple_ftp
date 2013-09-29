# SimpleFtp

this gems wraps Net::FTP and wraps two utility methods:

## rmdir!(directory_path)

will remove a directory specified as argument and its content.

## put_dir(local_directory, remote_directory = File.basename(local_directory))

copies local_directory to remote_directory.  
remote_directory is not a path but a basename, it will appear in the current remote pwd.


## Installation

Add this line to your application's Gemfile:

    gem 'simple_ftp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_ftp

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
