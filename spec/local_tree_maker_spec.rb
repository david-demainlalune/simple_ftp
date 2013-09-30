require 'spec_helper'

include Helpers


describe "SimpleFtp::LocalTreeMaker" do

 

  
  describe "its behavior" do
    it "should build a tree of local files given a directory argument" do

      tree = SimpleFtp::LocalTreeMaker.new('spec\test_data\test_directory').root

      tree.children.size.should eq(5)

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
  end
end