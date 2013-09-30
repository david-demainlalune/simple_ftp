#require "simple_ftp/version"
require "delegate"
require 'net/ftp'

module StringParser

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
		attr_reader :deleted
		def initialize(name=nil, type=nil, full_path=nil, children=[])
			@name = name
			@type = type
			@full_path = full_path
			@children = children
			@deleted = false
		end

		def directory?
			@type == :directory
		end

		def path
			@path ||= SimpleFtp::FtpPath.new(@full_path).split[0]
		end

		def file?
			! directory?
		end

		def delete(ftp)
			return if @deleted

			if directory?
				puts "deleted dir #{@full_path}"
				ftp.rmdir(@full_path)
			else
				puts "deleted file #{@full_path}"
				ftp.delete(@full_path)
			end
			@deleted = true
		end

		def no_children?
			@children.empty? || @children.all? { |f| f.deleted }
		end

	end
end


module SimpleFtp

	class TreeMaker

		include StringParser

		attr_reader :root
		
		def initialize(ftp, path_to_directory)
			@ftp = ftp
			@path = SimpleFtp::FtpPath.new(path_to_directory)
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
	class FtpPath
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
	class NotADirectory < StandardError
	end

	class RemoteDirectoryNameInvalid < StandardError
	end
end

module SimpleFtp

  class FTP < DelegateClass(Net::FTP)

  	include StringParser

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
			tree_root = SimpleFtp::TreeMaker.new(@ftp, path_str).root

			if tree_root.children.empty?
				@ftp.rmdir tree_root.full_path
			else
				stack = [tree_root]
				iterative_delete(stack)
			end
		end

		def putdir(local_directory, remote_directory=::File.basename(local_directory))
 			unless ::File.directory?(local_directory)
				raise NotADirectory, "#{::File.absolute_path(local_directory)} is not a directory"
			end

			if file_names.include?(remote_directory)
				raise RemoteDirectoryNameInvalid, "#{@ftp.pwd}/remote_directory} already exists on server"
			end
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

		def iterative_delete(stack)
			until stack.empty?

				next_dir = stack.last

				deleted_this_round = []

				if next_dir.no_children?
					next_dir.delete(@ftp)
					stack.pop
					next_dir = stack.last
					break if next_dir.nil?
				end

				puts next_dir.full_path

				next_dir.children.select(&:file?).each { |f| deleted_this_round.push(f) }
				next_dir.children.select { |f| f.directory? && f.no_children? }.each { |f| deleted_this_round.push(f) }
				next_dir.children.select { |f| f.directory? && ! f.no_children? }.each { |f| stack.push(f) }

				deleted_this_round.each { |f| f.delete(@ftp) }
			end
		end		
  end
end
