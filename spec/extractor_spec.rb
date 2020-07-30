require 'spec_helper'
require 'ffi/extractor'

require 'yaml'

describe FFI::Extractor do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  describe "abort!" do
    it "should throw :return, 1" do
      expect { subject.abort! }.to throw_symbol(:return, 1)
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

      expect(findings).to match(metadata)
    end
  end

  describe "extract_from" do
    it "should extract metadata from a file" do
      findings = []

      subject.extract_from(file) do |*arguments|
        findings << arguments
      end

      expect(findings).to match(metadata)
    end
  end
end
