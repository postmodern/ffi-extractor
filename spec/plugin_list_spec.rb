require 'spec_helper'
require 'ffi/extractor/plugin_list'

describe PluginList do
  let(:plugin) { 'mp3' }

  describe "defaults" do
    it "should load the default plugins" do
      lambda {
        described_class.defaults
      }.should_not raise_error(LoadError)
    end

    context "when no plugins could be loaded" do
      before { ENV['LIBEXTRACTOR_LIBRARIES'] = '/does/not/exist' }

      it "should raise LoadError" do
        lambda {
          described_class.defaults
        }.should raise_error(LoadError)
      end

      after { ENV.delete('LIBEXTRACTOR_LIBRARIES') }
    end
  end

  describe "#add" do
    it "should load an individual plugin" do
      subject.add(plugin)

      subject.to_ptr.should_not be_nil
    end

    context "when given an invalid plugin name" do
      it "should raise LoadError" do
        lambda {
          subject.add('foo')
        }.should raise_error(LoadError)
      end
    end
  end

  describe "#remove" do
    before { subject.add(plugin) }

    it "should remove a plugin from the list" do
      subject.remove(plugin)
    end

    context "when given an plugin name not in the list" do
      it "should raise LoadError" do
        lambda {
          subject.remove('foo')
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#remove_all" do
    context "when the plugin list is not empty" do
      before { subject.add(plugin) }

      it "should remove all plugins in the list" do
        subject.remove_all
      end
    end

    context "when the plugin list is empty" do
      it "should no-op" do
        subject.remove_all
      end
    end
  end
end
