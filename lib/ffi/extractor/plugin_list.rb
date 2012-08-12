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
    #
    # Represents the list of loaded extractor plugins.
    #
    class PluginList

      #
      # Initializes the plugin list.
      #
      # @param [FFI::Pointer] ptr
      #   The pointer to the list.
      #
      def initialize(ptr=nil)
        @ptr = ptr
      end

      #
      # Releases the plugin list.
      #
      # @param [FFI::Pointer] ptr
      #   The pointer to the list.
      #
      def self.release(ptr)
        Extractor.EXTRACTOR_plugin_remove_all(ptr)
      end

      #
      # Loads the installed extractor plugins.
      #
      # @param [Symbol] policy
      #   The policy for how the plugins will be ran.
      #
      # @return [PluginList]
      #   The loaded plugins.
      #
      # @raise [LoadError]
      #   The no plugins were loaded.
      #
      def self.default(policy=:default)
        ptr = Extractor.EXTRACTOR_plugin_add_defaults(policy)

        if ptr.null?
          raise(LoadError,"no plugins were loaded")
        end

        return new(ptr)
      end

      #
      # Loads a plugin and adds it to the list.
      #
      # @param [Symbol] name
      #   The plugin name.
      #
      # @param [String] options
      #   Options for the plugin.
      #
      # @param [Symbol] policy
      #   The policy for how the plugin will be ran.
      #
      # @return [PluginList]
      #   The modified plugin list.
      #
      # @raise [LoadError]
      #   The plugin could not be loaded.
      #
      def add(name,options='',policy=:default)
        name    = name.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_add(@ptr,name,options,policy)

        if new_ptr == @ptr
          raise(LoadError,"could not add #{name.dump} to the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      #
      # Removes a plugin from the list.
      #
      # @param [Symbol] name
      #   The plugin name.
      #
      # @return [PluginList]
      #   The modified plugin list.
      #
      # @raise [ArgumentError]
      #   The plugin could not be found in the list.
      #
      def remove(name)
        name    = name.to_s
        new_ptr = Extractor.EXTRACTOR_plugin_remove(@ptr,name)

        if new_ptr == @ptr
          raise(ArgumentError,"could not remove #{name.dump} from the plugin list")
        end

        @ptr = new_ptr
        return self
      end

      alias delete remove

      #
      # Removes all plugins from the list.
      #
      # @return [PluginList]
      #   The empty plugin list.
      #
      def remove_all
        Extractor.EXTRACTOR_plugin_remove_all(@ptr)
        return self
      end

      alias clear remove_all

      #
      # Converts the plugin list to a pointer.
      #
      # @return [FFI::Pointer]
      #   The pointer to the plugin list.
      #
      def to_ptr
        @ptr
      end

    end
  end
end
