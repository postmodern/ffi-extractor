require 'spec_helper'
require 'ffi/extractor'

require 'yaml'

describe FFI::Extractor do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end

  describe "abort!" do
    it "should throw :return" do
      lambda { subject.abort! }.should throw_symbol :return
    end
  end

  let(:file) { 'spec/files/image.jpg'   }
  let(:data) { File.new(file,'rb').read }

  let(:metadata) { YAML.load_file('spec/files/image.meta') }

  describe "extract" do
    it "should extract metadata from a String" do
      findings = []

      subject.extract(data) do |*arguments|
        findings << arguments
      end

      findings.should =~ metadata
    end
  end

  describe "extract_from" do
    it "should extract metadata from a file" do
      findings = []

      subject.extract_from(file) do |*arguments|
        findings << arguments
      end

      findings.should =~ metadata
    end
  end
end
