require 'spec_helper'
require 'ffi/extractor'

require 'yaml'

describe FFI::Extractor do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  describe ".abort!" do
    it "should throw :return, 1" do
      expect { subject.abort! }.to throw_symbol(:return, 1)
    end
  end

  let(:fixtures_dir) { File.expand_path('spec/fixtures')   }
  let(:file)         { File.join(fixtures_dir,'image.jpg') }
  let(:data)         { File.new(file,'rb').read            }

  let(:expected_metadata) do
    YAML.load_file(File.join(fixtures_dir,'image-metadata.yml'))
  end

  describe ".extract" do
    it "should extract metadata from a String" do
      findings = []

      subject.extract(data) do |*arguments|
        findings << arguments
      end

      expect(findings).to match(expected_metadata)
    end
  end

  describe ".extract_from" do
    it "should extract metadata from a file" do
      findings = []

      subject.extract_from(file) do |*arguments|
        findings << arguments
      end

      expect(findings).to match(expected_metadata)
    end
  end
end
