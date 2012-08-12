require 'spec_helper'
require 'ffi/extractor/metadata_processor'

describe MetadataProcessor do
  let(:plugin_name) { :pdf }
  let(:plugin) { "/usr/lib/libextractor/libextractor_#{plugin_name}.so" }

  it "should map plugin paths to names" do
    name = nil

    processor = described_class.new do |plugin_name,type,format,mime_type,data|
      name = plugin_name
    end
    processor.call(nil,plugin,:format,:utf8,'text/plain','PDF 1.5')

    name.should == plugin_name
  end
end
