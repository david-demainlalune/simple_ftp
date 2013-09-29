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

  
  describe "rmdir!" do
    it "should remove non empty directories" do
      test_directory = generate_test_dir_name 

      generate_files_and_directories_on_server(@ftp, test_directory)

      @ftp.rmdir!(test_directory)

      @ftp.file_names.should_not include(test_directory)
    end
  end
  
  after(:each) do
    @ftp.close
  end

end