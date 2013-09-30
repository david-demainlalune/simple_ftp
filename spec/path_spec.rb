require 'spec_helper'

describe "SimpleFtp::FtpPath" do

	describe "#absolute?" do
		it "should recognize absolute paths" do
    	SimpleFtp::FtpPath.new('/pipo/cerise').absolute?.should eq(true)
    end

    it "should recognize relative paths" do
    	SimpleFtp::FtpPath.new('pipo/cerise').absolute?.should eq(false)
    end
  end
	 
  describe "#split" do
    
  	it "should have a split method returning [path, basename]" do
  		SimpleFtp::FtpPath.new('pipo/cerise').split.should eq(['pipo', 'cerise'])	
  	end

  	it "should handle root" do
  		SimpleFtp::FtpPath.new('/').split.should eq(['/', '/'])	 
  	end

  	it "should handle '/cerise'" do
  		SimpleFtp::FtpPath.new('/cerise').split.should eq(['/', 'cerise'])	 
  	end

  	it "should handle 'cerise' " do
  		SimpleFtp::FtpPath.new('cerise').split.should eq(['.', 'cerise'])	 
  	end

  	it "should handle '/cerise/pipo'" do
  		SimpleFtp::FtpPath.new('/cerise/pipo').split.should eq(['/cerise', 'pipo'])	 
  	end

  	it "should handle 'cerise/pipo' " do
  		SimpleFtp::FtpPath.new('cerise/pipo').split.should eq(['cerise', 'pipo'])	 
  	end

  	it "should handle '/cerise/pipo/framboise'" do
  		SimpleFtp::FtpPath.new('/cerise/pipo/framboise').split.should eq(['/cerise/pipo', 'framboise'])	 
  	end

  	it "should handle 'cerise/pipo/framboise' " do
  		SimpleFtp::FtpPath.new('cerise/pipo/framboise').split.should eq(['cerise/pipo', 'framboise'])	 
  	end
  end


end