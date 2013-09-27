require 'spec_helper'

DOMAIN = 'ftp.demainlalune.ch'
FTP_LOGIN = 'ftp_test'
FTP_PASSWORD =  'asd135'
FTP_ROOT_DIR = 'data'
FTP_TEST_DIR = 'test'

include Helpers

describe "SimpleFtp::ftp base functionality" do

  it "works like NET::FTP" do
  	SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD) do |ftp|
      ftp.chdir(FTP_ROOT_DIR)
    	ftp.passive = true
    	ftp.put('spec/test_data/test.txt')
      ftp.file_names.should include('test.txt')
    
    end
  end
end

describe "it add functionality to Net::FTP" do

  before(:each) do
    @ftp = SimpleFtp::FTP.open(DOMAIN, FTP_LOGIN, FTP_PASSWORD)
    @ftp.chdir("#{FTP_ROOT_DIR}/#{FTP_TEST_DIR}")
  end

  
  pending "rmdir!" do
    pending "should remove non empty directories" do
      test_directory = generate_test_dir_name 

      @ftp.mkdir(test_directory)
      @ftp.chdir(test_directory)
      @ftp.put('spec/test_data/test.txt')

      @ftp.mkdir("pipo")
      @ftp.chdir("pipo")
      @ftp.put('spec/test_data/test.txt')
      
      @ftp.mkdir("cerises")
      @ftp.chdir("cerises")
      @ftp.put('spec/test_data/test.txt')
      @ftp.mkdir('framboises')

      @ftp.chdir('..')
      @ftp.chdir('..')
      @ftp.chdir('..')
      @ftp.rmdir!(test_directory)

      @ftp.file_names.should_not include(test_directory)
    end
  end
  
  after(:each) do
    @ftp.close
  end

end