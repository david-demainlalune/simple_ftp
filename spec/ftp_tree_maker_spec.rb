require 'spec_helper'

include Helpers


describe "SimpleFtp::FtpTreeMaker" do

  before(:each) do
    @ftp = SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD)
    @ftp.chdir("#{FTP_TEST_DIR}")
  end

  
  describe "its behavior" do
    it "should build a tree given a directory argument" do
      test_directory = generate_test_dir_name 

      generate_files_and_directories_on_server(@ftp, test_directory)


     	treeRoot = SimpleFtp::FtpTreeMaker.new(@ftp, test_directory).root
     	treeRoot.children.size.should eq(2)

     	treeRoot.children.map(&:name).to_set.should eq(['pipo', 'test.txt'].to_set)

     	pipo_dir_index = treeRoot.children.index { |f| f.name == 'pipo'}
     	pipo_dir = treeRoot.children[pipo_dir_index]

     	pipo_dir.children.size.should eq(2)
      pipo_dir.children.map(&:name).to_set.should eq(['cerises', 'test2.txt'].to_set)

     	cerises_dir_index = pipo_dir.children.index { |f| f.name == 'cerises'}
     	cerises_dir = pipo_dir.children[cerises_dir_index]

     	cerises_dir.children.size.should eq(2)
      cerises_dir.children.map(&:name).to_set.should eq(['framboises', 'test3.txt'].to_set)
    end

    it "should accept absolute paths" do
      test_directory = generate_test_dir_name 

      generate_files_and_directories_on_server(@ftp, test_directory)

      absolute_path_to_test_directory = "#{FTP_TEST_DIR}/#{test_directory}"

      treeRoot = SimpleFtp::FtpTreeMaker.new(@ftp, absolute_path_to_test_directory).root
      treeRoot.children.size.should eq(2)

      treeRoot.children.map(&:name).to_set.should eq(['pipo', 'test.txt'].to_set)
    end

  end
  
  after(:each) do
    @ftp.close
  end

end