module SimpleFtp
	class LocalFile

		# provides a mapping between a local file and a desired remote file
		#
		# :remote_relative_path indicates the files relative position to a remote location
		# this is used to place the file on the ftp server
		#
		# :full_path is used to locate file on local storage

		attr_accessor :children
		attr_reader :name, :full_path, :remote_relative_path

		def initialize(name, type, full_path, remote_relative_path)
			@name = name
			@type = type
			@full_path = full_path
			@remote_relative_path = remote_relative_path
			@children = []
		end

		def directory?
			@type == :directory
		end

		def file?
			! directory?
		end

		def self.make_directory(name, full_path, remote_relative_path)
			LocalFile.new(name, :directory, full_path, remote_relative_path)
		end

		def self.make_file(name, full_path, remote_relative_path)
			LocalFile.new(name, :file, full_path, remote_relative_path)
		end
	end
	
end