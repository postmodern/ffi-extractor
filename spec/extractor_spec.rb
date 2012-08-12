require 'spec_helper'
require 'ffi/extractor'

describe FFI::Extractor do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end

  describe "abort!" do
    it "should throw :return" do
      lambda { subject.abort! }.should throw_symbol :return
    end

    it "should stop the extraction process" do
    end
  end

  describe "extract" do
  end

  describe "extract_from" do
  end
end
