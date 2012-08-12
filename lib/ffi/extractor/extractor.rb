#
# ffi-extractor - Ruby FFI bindings for libextractor
#
# Copyright (c) 2012 - Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ffi/extractor/library'
require 'ffi/extractor/metadata_processor'
require 'ffi/extractor/plugin_list'

module FFI
  module Extractor
    #
    # The default list of plugins.
    #
    # @return [PluginList]
    #   The plugin list.
    #
    def self.plugins
      @plugins ||= PluginList.default
    end

    #
    # Aborts metadata extraction.
    #
    def self.abort!
      throw :return, 1
    end

    #
    # Extracts metadata.
    #
    # @param [String] data
    #   The data to extract from.
    #
    # @param [PluginList] plugins
    #   The extraction plugins to use.
    #
    # @yield [plugin_name, type, format, mime_type, data]
    #   The given block will be passed the extracted metadata.
    #
    # @yieldparam [Symbol] plugin_name
    #   The name of the plugin.
    #
    # @yieldparam [Symbol] type
    #   The type of metadata.
    #
    # @yieldparam [:unknown, :utf8, :binary, :c_string] format
    #   The format of the metadata.
    #
    # @yieldparam [String] mime_type
    #   The MIME-type of the data.
    #
    # @yieldparam [String] data
    #   The extracted metadata.
    #
    def self.extract(data,plugins=Extractor.plugins,&block)
      processor = MetadataProcessor.new(&block)

      Extractor.EXTRACTOR_extract(plugins,nil,data,data.length,processor,nil)
    end

    #
    # Extracts metadata from a file.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @param [PluginList] plugins
    #   The extraction plugins to use.
    #
    # @yield [plugin_name, type, format, mime_type, data]
    #   The given block will be passed the extracted metadata.
    #
    # @yieldparam [Symbol] plugin_name
    #   The name of the plugin.
    #
    # @yieldparam [Symbol] type
    #   The type of metadata.
    #
    # @yieldparam [:unknown, :utf8, :binary, :c_string] format
    #   The format of the metadata.
    #
    # @yieldparam [String] mime_type
    #   The MIME-type of the data.
    #
    # @yieldparam [String] data
    #   The extracted metadata.
    #
    def self.extract_from(path,plugins=Extractor.plugins,&block)
      processor = MetadataProcessor.new(&block)

      Extractor.EXTRACTOR_extract(plugins,path,nil,0,processor,nil)
    end
  end
end
