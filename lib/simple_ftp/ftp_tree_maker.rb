require 'simple_ftp/string_parser'

module SimpleFtp

	class FtpTreeMaker


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

			@root = FtpFile.new(target_dir, :directory, "#{@current_path}/#{target_dir}")
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