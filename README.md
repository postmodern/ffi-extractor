# ffi-extractor

* [Homepage](https://github.com/postmodern/ffi-extractor#readme)
* [Issues](https://github.com/postmodern/ffi-extractor/issues)
* [Documentation](http://rubydoc.info/gems/ffi-extractor/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)
* [![Build Status](https://travis-ci.org/postmodern/ffi-extractor.svg)](https://travis-ci.org/postmodern/ffi-extractor)

## Description

Ruby FFI bindings to [libextractor], a library for extracting metadata from
a variety of file formats.

[libextractor] is a simple library for keyword extraction.  libextractor
does not support all formats but supports a simple plugging mechanism
such that you can quickly add extractors for additional formats, even
without recompiling libextractor.  libextractor typically ships with a
dozen helper-libraries that can be used to obtain keywords from common
file-types.

libextractor is a part of the [GNU project](http://www.gnu.org/).

## Examples

    require 'ffi/extractor'

    FFI::Extractor.extract(data) do |plugin,type,format,mime_type,data|
      # ...
    end

    FFI::Extractor.extract_from(path) do |plugin,type,format,mime_type,data|
      # ...
    end

## Requirements

* [libextractor] >= 0.6.0
* [ffi] ~> 1.0

## Install

    $ gem install ffi-extractor

### Debian / Ubuntu

    $ sudo apt-get install libextractor-dev libextractor-plugins-all

### RedHat Fedora

    $ sudo dnf install libextractor-devel libextractor-plugins

### OSX

    $ brew install libextractor

## Crystal

[extractor.cr] is a Crystal port of this library.

[extractor.cr]: https://github.com/postmodern/extractor.cr#readme

## Copyright

ffi-extractor - Ruby FFI bindings for libextractor

Copyright (c) 2012 - Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

[libextractor]: http://www.gnu.org/software/libextractor
[ffi]: https://github.com/ffi/ffi#readme
