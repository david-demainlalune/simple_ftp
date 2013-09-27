require 'spec_helper'

describe "SimpleFtp::Path" do

	describe "#absolute?" do
		it "should recognize absolute paths" do
    	SimpleFtp::Path.new('/pipo/cerise').absolute?.should eq(true)
    end

    it "should recognize relative paths" do
    	SimpleFtp::Path.new('pipo/cerise').absolute?.should eq(false)
    end
  end
	 
  describe "#split" do
    
  	it "should have a split method returning [path, basename]" do
  		SimpleFtp::Path.new('pipo/cerise').split.should eq(['pipo', 'cerise'])	
  	end

  	it "should handle root" do
  		SimpleFtp::Path.new('/').split.should eq(['/', '/'])	 
  	end

  	it "should handle '/cerise'" do
  		SimpleFtp::Path.new('/cerise').split.should eq(['/', 'cerise'])	 
  	end

  	it "should handle 'cerise' " do
  		SimpleFtp::Path.new('cerise').split.should eq(['.', 'cerise'])	 
  	end

  	it "should handle '/cerise/pipo'" do
  		SimpleFtp::Path.new('/cerise/pipo').split.should eq(['/cerise', 'pipo'])	 
  	end

  	it "should handle 'cerise/pipo' " do
  		SimpleFtp::Path.new('cerise/pipo').split.should eq(['cerise', 'pipo'])	 
  	end

  	it "should handle '/cerise/pipo/framboise'" do
  		SimpleFtp::Path.new('/cerise/pipo/framboise').split.should eq(['/cerise/pipo', 'framboise'])	 
  	end

  	it "should handle 'cerise/pipo/framboise' " do
  		SimpleFtp::Path.new('cerise/pipo/framboise').split.should eq(['cerise/pipo', 'framboise'])	 
  	end
  end


end