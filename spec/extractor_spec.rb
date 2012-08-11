require 'spec_helper'
require 'ffi/extractor'

describe FFI::Extractor do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
