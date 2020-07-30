require 'spec_helper'
require 'ffi/extractor/metadata_processor'

describe FFI::Extractor::MetadataProcessor do
  let(:plugin_name) { :pdf }
  let(:plugin)      { "/usr/lib/libextractor/libextractor_#{plugin_name}.so" }
  let(:type)        { :format }
  let(:format)      { :utf8 }
  let(:mime_type)   { 'text/plain' }
  let(:data)        { 'PDF 1.5' }
  let(:size)        { data.length }

  let(:buffer) do
    FFI::Buffer.new(size + 1).tap do |buffer|
      buffer.put_bytes(0,data)
    end
  end

  subject do
    processor = described_class.new do |plugin_name,type,format,mime_type,data|
      @yielded_plugin_name = plugin_name
      @yielded_type        = type
      @yielded_format      = format
      @yielded_mime_type   = mime_type
      @yielded_data        = data
    end
  end

  before { subject.call(nil,plugin,type,format,mime_type,buffer,size) }

  describe "yielded arguments" do
    it "should map plugin paths to names" do
      expect(@yielded_plugin_name).to eq(plugin_name)
    end

    it "should yield the type" do
      expect(@yielded_type).to eq(type)
    end

    it "should yield the format" do
      expect(@yielded_format).to eq(format)
    end

    it "should yield the mime-type" do
      expect(@yielded_mime_type).to eq(mime_type)
    end

    describe "data" do
      context "when passed binary" do
        before { subject.call(nil,plugin,:binary,format,mime_type,buffer,size) }

        it "should yield the bytes" do
          expect(@yielded_data).to eq(data)
        end
      end

      context "when passwd a c_string" do
        before { subject.call(nil,plugin,:c_string,format,mime_type,buffer,size) }

        it "should yield the string" do
          expect(@yielded_data).to eq(data)
        end
      end

      context "when passwd utf8" do
        before { subject.call(nil,plugin,:utf8,format,mime_type,buffer,size) }

        it "should yield the string" do
          expect(@yielded_data).to eq(data)
        end
      end
    end
  end

  it "should return 0 by default" do
    expect(subject.call(nil,plugin,type,format,mime_type,buffer,size)).to eq(0)
  end

  context "when :return is thrown" do
    subject do
      described_class.new do |plugin_name,type,format,mime_type,data|
        throw :return, 1
      end
    end

    it "should catch :abort" do
      expect(subject.call(nil,plugin,type,format,mime_type,buffer,size)).to eq(1)
    end
  end
end
