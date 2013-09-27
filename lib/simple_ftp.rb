#require "simple_ftp/version"
require "delegate"
require 'net/ftp'

module Parser

		def parse_files(files_as_list_output)
			# takes an array of strings
			# returns an array of SimpleFtp::File objects
			remove_dot_and_double_dot(files_as_list_output).map do |f| 
				filename = f.split.last
				type = is_directory?(f) ? :directory : :file
				full_path = "#{@ftp.pwd}/#{filename}"
				SimpleFtp::File.new(filename, type, full_path)
			end
		end

		def is_directory?(file_as_list_output)
			file_as_list_output  =~ /\Ad/
		end

		def remove_dot_and_double_dot(file_as_list_output)
			# returns array of strings
			# with files "." and ".." removece
			file_as_list_output.reject { |f| f =~ / \.{1,2}\z/ }
		end

end

module SimpleFtp
	class File
		attr_accessor :name, :type, :children, :full_path
		def initialize(name=nil, type=nil, full_path=nil, children=nil)
			@name = name
			@type = type
			@full_path = full_path
			@children = children
		end

		def directory?
			@type == :directory
		end

		def path
			@path ||= SimpleFtp::Path.new(@full_path).split[0]
		end

		def file?
			! is_directory?
		end

	end
end


module SimpleFtp

	class TreeMaker

		include Parser

		attr_reader :root
		
		def initialize(ftp, path_to_directory)
			@ftp = ftp
			@path = SimpleFtp::Path.new(path_to_directory)
			@current_path = @ftp.pwd
			build
		end

		private
		def build
			path_to, target_dir = @path.split

			@root = File.new(target_dir, :directory, "#{@current_path}/#{target_dir}")
			build_node(@root)
			@ftp.chdir(@current_path)
		end

		def build_node(file)
			@ftp.chdir(file.full_path)
			file.children = parse_files(@ftp.list)
			file.children.select(&:directory?).each { |file| build_node file}
		end

		def chdir(dir)
			@ftp.chdir(path_to)
			puts "changed dir to #{@ftp.pwd}"
		end
	end

end

module SimpleFtp
	class Path
		def initialize(path)
			@path = path
		end
		
		def to_s
			@path
		end

		def absolute?
			!!(@path =~ /^\//)
		end

		def split
			return ['/', '/'] if @path == '/'
			if absolute?
				absolute_split
			else
				relative_split
			end

		end

		private
		def absolute_split
			result = @path.split('/').reject(&:empty?)
			["/#{result[0...-1].join('/')}" , result.last]
		end

		def relative_split
			result = @path.split('/').reject(&:empty?)
			if result.length == 1
				['.', result.first]
			else
				[result[0...-1].join('/') , result.last]
			end
		end
	end
end

module SimpleFtp
  class FTP < DelegateClass(Net::FTP)

  	include Parser

		def initialize(host = nil, user = nil, passwd = nil, acct = nil)
			@ftp = Net::FTP.new(host, user, passwd, acct)
			super(@ftp)
		end

		def file_names
			files.map(&:name)
		end

		def files
			parse_files(self.list)
		end

		def rmdir!(path_str)
			path = SimpleFtp::Path.new(path_str)
			current_path = @ftp.pwd

			path, target_dir = path.split

			@ftp.chdir(path)
			puts "changed dir to #{@ftp.pwd}"
			until directory_empty? target_dir
				delete_all(target_dir)
				@ftp.chdir(current_path)
			end
			@ftp.rmdir(target_dir)
			puts "changed dir to #{@ftp.pwd}"
		end


		# mimic class level func (Net::FTP#open)
		def self.open(host, user = nil, passwd = nil, acct = nil)
			if block_given?
				ftp = new(host, user, passwd, acct)
				begin
					yield ftp
				ensure
					ftp.close
				end
			else
				new(host, user, passwd, acct)
			end
		end

		private


		def directory_empty?(directory)
			puts "calling directory_empty? on #{directory} with path #{@ftp.pwd}"
			current = @ftp.pwd
			@ftp.chdir(directory)
			result = file_names.size == 0
			@ftp.chdir(current)
			result
		end

		def delete_all(target_directory)
			if directory_empty? target_directory
				@ftp.rmdir target_directory
				puts "removed directory #{@ftp.pwd}/#{target_directory}"
			else
				@ftp.chdir target_directory
				puts "changed dir to #{@ftp.pwd}"
				files.each do |file|
					if file.directory?
						delete_all(file.name)
					else
						@ftp.delete(file.name)
						puts "removed file #{@ftp.pwd}/#{file.name}"
					end
				end
			end
		end		
  end
end
