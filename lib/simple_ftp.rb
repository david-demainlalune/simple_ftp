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
