require 'spec_helper'

DOMAIN = 'ftp.demainlalune.ch'
FTP_LOGIN = 'ftp_test'
FTP_PASSWORD =  'asd135'
FTP_ROOT_DIR = 'data'
FTP_TEST_DIR = 'test'

include Helpers



describe "SimpleFtp::TreeMaker" do

  before(:each) do
    @ftp = SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD)
    @ftp.chdir("#{FTP_ROOT_DIR}/#{FTP_TEST_DIR}")
  end

  
  describe "its behavior" do
    it "should build a tree given a directory argument" do
      test_directory = generate_test_dir_name 

      @ftp.mkdir(test_directory)
      @ftp.chdir(test_directory)
      @ftp.put('spec/test_data/test.txt')

      @ftp.mkdir("pipo")
      @ftp.chdir("pipo")
      @ftp.put('spec/test_data/test.txt', 'test2.txt')
      
      @ftp.mkdir("cerises")
      @ftp.chdir("cerises")
      @ftp.put('spec/test_data/test.txt', 'test3.txt')
      @ftp.mkdir('framboises')

      @ftp.chdir('..')
      @ftp.chdir('..')
      @ftp.chdir('..')
	     

     	treeRoot = SimpleFtp::TreeMaker.new(@ftp, test_directory).root
     	treeRoot.children.size.should eq(2)

     	treeRoot.children.map(&:name).should include('test.txt')
     	treeRoot.children.map(&:name).should include('pipo')

     	pipo_dir_index = treeRoot.children.index { |f| f.name == 'pipo'}
     	pipo_dir = treeRoot.children[pipo_dir_index]

     	pipo_dir.children.size.should eq(2)
     	pipo_dir.children.map(&:name).should include('test2.txt')
     	pipo_dir.children.map(&:name).should include('cerises')

     	cerises_dir_index = pipo_dir.children.index { |f| f.name == 'cerises'}
     	cerises_dir = pipo_dir.children[cerises_dir_index]

     	cerises_dir.children.size.should eq(2)
     	cerises_dir.children.map(&:name).should include('test3.txt')
     	cerises_dir.children.map(&:name).should include('framboises')

    end
  end
  
  after(:each) do
    @ftp.close
  end

end