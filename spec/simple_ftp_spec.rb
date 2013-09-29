require 'spec_helper'



include Helpers

describe "SimpleFtp::ftp base functionality" do

  it "works like NET::FTP" do
  	SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD) do |ftp|
      ftp.chdir(FTP_TEST_DIR)
    	ftp.passive = true
    	ftp.put('spec/test_data/test.txt')
      ftp.file_names.should include('test.txt')
    
    end
  end
end

describe "it add functionality to Net::FTP" do

  before(:each) do
    @ftp = SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD)
    @ftp.chdir(FTP_TEST_DIR)
  end

  
  describe "#rmdir!" do
    it "should remove non empty directories" do
      test_directory = generate_test_dir_name 

      generate_files_and_directories_on_server(@ftp, test_directory)

      @ftp.rmdir!(test_directory)

      @ftp.file_names.should_not include(test_directory)
    end
  end
  
  describe "#putdir" do
    it "should handle garbage path as local_directory" do
      expect { @ftp.putdir('mighty garbage gods') }.to raise_error(SimpleFtp::NotADirectory)
    end

    it "argument local_directory should point to a valid directory" do
      expect { @ftp.putdir('spec/test_data/test.txt') }.to raise_error(SimpleFtp::NotADirectory)
    end

    it "should raise an error if the remote directory already exists" do
      a_remote_directory = make_random_test_directory(@ftp)

      @ftp.file_names.should include(a_remote_directory)

      expect { @ftp.putdir('spec/test_data/test_directory', 
                a_remote_directory) }.to raise_error(SimpleFtp::RemoteDirectoryNameInvalid)
    end

    it "should copy the directory otherwise" do
      test_directory = generate_test_dir_name
      @ftp.putdir('spec/test_data/test_directory', test_directory)

      remote_tree = SimpleFtp::TreeMaker.new(@ftp, test_directory).root

      remote_tree.children.size.should eq(5)

    end

  end


  after(:each) do
    @ftp.close
  end

end