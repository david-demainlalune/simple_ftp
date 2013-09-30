module StringParser

		def parse_files(files_as_list_output)
			# takes an array of strings
			# returns an array of SimpleFtp::File objects
			remove_dot_and_double_dot(files_as_list_output).map do |f| 
				filename = f.split.last
				type = is_directory?(f) ? :directory : :file
				full_path = "#{@ftp.pwd}/#{filename}"
				SimpleFtp::FtpFile.new(filename, type, full_path)
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