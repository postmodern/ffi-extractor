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

require 'ffi'

module FFI
  module Extractor
    class MetadataProcessor

      # Mapping of plugin paths to names
      PLUGIN_NAMES = Hash.new do |plugin_names,plugin|
        libname = File.basename(plugin,File.extname(plugin))

        plugin_names[plugin] = libname.sub('libextractor_','').to_sym
      end

      #
      # Wraps a Metadata Processor callback.
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
      # @yieldparam [String, FFI::Pointer] data
      #   The extracted metadata. If the `type` is `:unknown`, the original
      #   `FFI::Pointer` object will be yielded.
      #
      def initialize(&block)
        @callback = block
      end

      #
      # Invokes the callback.
      #
      # @param [FFI::Pointer] cls
      #
      # @param [String] plugin
      #   The libextractor plugin name.
      #
      # @param [Symbol] type
      #   The `extractor_meta_type`.
      #
      # @param [Symbol] format
      #   The `extractor_meta_format`.
      #
      # @param [String] mime_type
      #   The MIME type of the data.
      #
      # @param [FFI::Pointer] data
      #   The pointer to the data.
      #
      # @param [Integer] size
      #   The size of the data.
      #
      # @return [0, 1]
      #   `0` indicates to libextractor that the metadata processor should
      #   contain. `1` indicates that the metadata processor wishes to abort.
      #
      def call(cls,plugin,type,format,mime_type,data,size)
        catch(:return) do
          value = case format
                  when :c_string, :utf8 then data.get_string(0,size)
                  when :binary          then data.get_bytes(0,size)
                  else                       data
                  end

          @callback.call(PLUGIN_NAMES[plugin],type,format,mime_type,value)

          0
        end
      end

      #
      # Converts the metadata processor to a Proc.
      #
      # @return [Proc]
      #
      def to_proc
        method(:call).to_proc
      end

    end
  end
end
