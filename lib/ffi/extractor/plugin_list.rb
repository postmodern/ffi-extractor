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

require 'ffi/extractor/extractor'

module FFI
  module Extractor
    class PluginList

      def initialize(ptr)
        @ptr = ptr
      end

      def self.release(ptr)
        Extractor.EXTRACTOR_plugin_remove_all(self)
      end

      def self.defaults(option)
        new(Extractor.EXTRACTOR_plugin_add_defaults(option))
      end

      def add(library,library_options,option)
        library = library.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_add(self,library,library_options,option)

        if new_ptr == @ptr
          raise("could not add #{library.dump} to the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      def remove(library)
        library = library.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_remove(self,library)

        if new_ptr == @ptr
          raise("could not remove #{library.dump} from the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      alias remove delete

      def remove_all
        Extractor.EXTRACTOR_plugin_remove_all(self)
      end

      alias remove_all clear

      def to_ptr
        @ptr
      end

    end
  end
end
