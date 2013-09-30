module SimpleFtp
	class FtpFile
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