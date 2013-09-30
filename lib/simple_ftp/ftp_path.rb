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