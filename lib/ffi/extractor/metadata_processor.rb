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

module FFI
  module Extractor
    class MetadataProcessor < Proc

      PLUGIN_NAMES = Hash.new do |plugin_names,plugin|
        libname = File.basename(plugin).chomp(File.extname(plugin))

        plugin_names[plugin] = libname.sub('libextractor_','').to_sym
      end

      def self.new(&block)
        super do |cls,plugin,type,format,mime_type,data,size|
          catch(:abort) {
            yield PLUGIN_NAMES[plugin], type, format, mime_type, data
          } || 0
        end
      end

    end
  end
end
