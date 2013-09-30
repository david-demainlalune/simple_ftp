module SimpleFtp
	class LocalFile
		attr_accessor :children
		attr_reader :name, :full_path, :relative_to_root_path

		def initialize(name, type, full_path, relative_to_root_path, children=[])
			@name = name
			@type = type
			@full_path = full_path
			@relative_to_root_path = relative_to_root_path
			@children = children
		end

		def directory?
			type == :directory
		end

		def file?
			! directory?
		end
		
		def self.make_directory(name, full_path, relative_to_root_path, children=[])
			LocalFile.new(name, :directory, full_path, relative_to_root_path, children)
		end

		def self.make_file(name, full_path, relative_to_root_path, children=[])
			LocalFile.new(name, :file, full_path, relative_to_root_path, children)
		end
	end
	
end