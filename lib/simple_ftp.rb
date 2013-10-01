require "delegate"
require 'net/ftp'

Dir[File.dirname(__FILE__) + '/simple_ftp/*.rb'].each { |file| require file }

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
			tree_root = SimpleFtp::FtpTreeMaker.new(@ftp, path_str).root

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

			local_tree = LocalTreeMaker.new(local_directory, remote_directory).root

			stack = [local_tree]

			iterative_putdir(stack, remote_directory)
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

				directories, files = next_dir.children.partition(&:directory?)
				empty_directories, non_empty_directories = directories.partition(&:no_children?)

				files.each { |f| deleted_this_round.push(f) }
				empty_directories.each { |f| deleted_this_round.push(f) }
				non_empty_directories.each { |f| stack.push(f) }

				deleted_this_round.each { |f| f.delete(@ftp) }
			end
		end

		def iterative_putdir(stack, remote_head_directory)
			ftp_head_dir = @ftp.pwd

			until stack.empty?
				current_node = stack.pop
				new_dir_path = File.join(ftp_head_dir, current_node.remote_relative_path)
				@ftp.mkdir(new_dir_path)
				@ftp.chdir(new_dir_path)
				directories, files = current_node.children.partition { |n| n.directory? }
				files.each { |f| @ftp.put(f.full_path) }
				directories.each { |d| stack.push(d) }
			end

			@ftp.chdir(ftp_head_dir)
		end	
  end
end
