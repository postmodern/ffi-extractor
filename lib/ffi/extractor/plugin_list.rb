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

module FFI
  module Extractor
    class PluginList

      def initialize(ptr=nil)
        @ptr = ptr
      end

      def self.release(ptr)
        Extractor.EXTRACTOR_plugin_remove_all(ptr)
      end

      def self.default(policy=:default)
        ptr = Extractor.EXTRACTOR_plugin_add_defaults(policy)

        if ptr.null?
          raise(LoadError,"no plugins were loaded")
        end

        return new(ptr)
      end

      def add(library,options='',policy=:default)
        library = library.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_add(@ptr,library,options,policy)

        if new_ptr == @ptr
          raise(LoadError,"could not add #{library.dump} to the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      def remove(library)
        library = library.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_remove(@ptr,library)

        if new_ptr == @ptr
          raise(ArgumentError,"could not remove #{library.dump} from the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      alias delete remove

      def remove_all
        Extractor.EXTRACTOR_plugin_remove_all(@ptr)
      end

      alias clear remove_all

      def to_ptr
        @ptr
      end

    end
  end
end
