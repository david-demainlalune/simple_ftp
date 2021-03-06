require 'spec_helper'

include Helpers


describe "SimpleFtp::LocalTreeMaker" do
  
  describe "its behavior" do
    it "should build a tree of local files given a directory argument" do

      tree = SimpleFtp::LocalTreeMaker.new('spec/test_data/test_directory').root

      tree.children.map(&:name).to_set.should eq(['test_a', 'test_aa', 'test_aaa', 'test_a.txt', 'test_aa.txt'].to_set)

      test_a_index = tree.children.index { |f| f.name == 'test_a'}
      test_a_dir = tree.children[test_a_index]
      test_a_dir.children.map(&:name).to_set.should eq(['test_b', 'test_b.txt'].to_set)

      test_aaa_index = tree.children.index { |f| f.name == 'test_aaa'}
      test_aaa_dir = tree.children[test_aaa_index]
      test_aaa_dir.children.map(&:name).to_set.should eq(['test_c', 'test_cc'].to_set)

      test_cc_index = test_aaa_dir.children.index { |f| f.name == 'test_cc'}
      test_cc_dir = test_aaa_dir.children[test_cc_index]
      test_cc_dir.children.map(&:name).to_set.should eq(['test_d.txt'].to_set)
    end

    it "should hold reference to the path relative to the root" do
      tree = SimpleFtp::LocalTreeMaker.new('spec/test_data/test_directory').root
      test_a_index = tree.children.index { |f| f.name == 'test_a'}
      test_a_dir = tree.children[test_a_index]
      test_a_dir.remote_relative_path.should eq('test_directory/test_a')

      test_b_index = test_a_dir.children.index { |f| f.name == 'test_b'}
      test_b_dir = test_a_dir.children[test_b_index]
      test_b_dir.remote_relative_path.should eq('test_directory/test_a/test_b')
    end

    it "path_relative_to_root should point to a root == remote_directory if remote_directory given" do
      tree = SimpleFtp::LocalTreeMaker.new('spec/test_data/test_directory', 'remote_directory_name').root
      test_a_index = tree.children.index { |f| f.name == 'test_a'}
      test_a_dir = tree.children[test_a_index]
      test_a_dir.remote_relative_path.should eq('remote_directory_name/test_a')

      test_b_index = test_a_dir.children.index { |f| f.name == 'test_b'}
      test_b_dir = test_a_dir.children[test_b_index]
      test_b_dir.remote_relative_path.should eq('remote_directory_name/test_a/test_b')
      
    end
  end
end