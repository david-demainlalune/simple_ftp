#require 'fileutils'

module SimpleFtp
	class LocalTreeMaker
		
		attr_reader :root

		def initialize(directory_path)
			@directory_path = directory_path
			@root = LocalFile.make_directory(File.basename(directory_path), 
																			 File.absolute_path(directory_path), 
																			 File.basename(directory_path))
			build @root
		end

		private
		def build(node)
			entries = get_entries node

			directories, files = entries.partition { |f| File.directory?(File.join(node.full_path, f)) }

			files.each do |f| 
				file_node = LocalFile.make_file(f, 
																				File.join(node.full_path, f), 
																				File.join(node.relative_to_root_path, f))
				node.children.push file_node
			end

			directories.each do |d|
				directory_node = LocalFile.make_directory(d, 
																									File.join(node.full_path, d), 
																									File.join(node.relative_to_root_path, d))
				node.children.push directory_node
				build(directory_node)
			end

		end

		def get_entries (node)
			Dir.entries(node.full_path).reject { |f| f =~ /^\.{1,2}$/}
		end
	end
	
end