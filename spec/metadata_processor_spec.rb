require 'spec_helper'
require 'ffi/extractor/metadata_processor'

describe MetadataProcessor do
  let(:plugin_name) { :pdf }
  let(:plugin)      { "/usr/lib/libextractor/libextractor_#{plugin_name}.so" }
  let(:type)        { :format }
  let(:format)      { :utf8 }
  let(:mime_type)   { 'text/plain' }
  let(:data)        { 'PDF 1.5' }

  subject do
    processor = described_class.new do |plugin_name,type,format,mime_type,data|
      @yielded_plugin_name = plugin_name
      @yielded_type        = type
      @yielded_format      = format
      @yielded_mime_type   = mime_type
      @yielded_data        = data
    end
  end

  before { subject.call(nil,plugin,type,format,mime_type,data) }

  describe "yielded arguments" do
    it "should map plugin paths to names" do
      @yielded_plugin_name.should == plugin_name
    end

    it "should yield the type" do
      @yielded_type.should == type
    end

    it "should yield the format" do
      @yielded_format.should == format
    end

    it "should yield the mime-type" do
      @yielded_mime_type.should == mime_type
    end

    it "should yield the data" do
      @yielded_data.should == data
    end
  end

  it "should return 0 by default" do
    subject.call(nil,plugin,type,format,mime_type,data).should == 0
  end

  context "when :return is thrown" do
    subject do
      described_class.new do |plugin_name,type,format,mime_type,data|
        throw :return, 1
      end
    end

    it "should catch :abort" do
      subject.call(nil,plugin,type,format,mime_type,data).should == 1
    end
  end
end
