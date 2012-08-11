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
    extend FFI::Library

    enum :extractor_options, [
      :default_policy, 0,
      :out_of_process_no_restart, 1,
      :in_process, 2,
      :disabled, 3
    ]

    enum :extractor_meta_format, [
      :unknown, 0,
      :utf8, 1,
      :binary, 2,
      :c_string, 3
    ]

    enum :extractor_meta_type, [
      # fundamental types
      :reserved, 0,
      :mimetype, 1,
      :filename, 2,
      :comment, 3,

      # Standard types from bibtex
      :title, 4,
      :book_title, 5,
      :book_edition, 6,
      :book_chapter_number, 7,
      :journal_name, 8,
      :journal_volume, 9,    
      :journal_number, 10,
      :page_count, 11,
      :page_range, 12,
      :author_name, 13,
      :author_email, 14,
      :author_institution, 15,
      :publisher, 16,
      :publisher_address, 17,
      :publisher_institution, 18,
      :publisher_series, 19,
      :publication_type, 20,
      :publication_year, 21,
      :publication_month, 22,
      :publication_day, 23,
      :publication_date, 24,
      :bibtex_eprint, 25,
      :bibtex_entry_type, 26,
      :language, 27,
      :creation_time, 28,
      :url, 29,

      # "unique" document identifiers
      :uri, 30, 
      :isrc, 31,
      :hash_md4, 32,
      :hash_md5, 33,
      :hash_sha0, 34,
      :hash_sha1, 35,
      :hash_rmd160, 36,

      # identifiers of a location
      :gps_latitude_ref, 37,
      :gps_latitude, 38,
      :gps_longitude_ref, 39,
      :gps_longitude, 40,
      :location_city, 41,
      :location_sublocation, 42,
      :location_country, 43,
      :location_country_code, 44,

      # generic attributes
      :unknown, 45,
      :description, 46,
      :copyright, 47,
      :rights, 48,
      :keywords, 49,
      :abstract, 50,
      :summary, 51,
      :subject, 52,
      :creator, 53,
      :format, 54,
      :format_version, 55,

      # processing history
      :created_by_software, 56, 
      :unknown_date, 57, 
      :creation_date, 58,
      :modification_date, 59,
      :last_printed, 60,
      :last_saved_by, 61,
      :total_editing_time, 62,
      :editing_cycles, 63,
      :modified_by_software, 64,
      :revision_history, 65,

      :embedded_file_size, 66,
      :finder_file_type, 67,
      :finder_file_creator, 68,

      # software package specifics (deb, rpm, tgz, elf)
      :package_name, 69,
      :package_version, 70,
      :section, 71,
      :upload_priority, 72,
      :package_dependency, 73,
      :package_conflicts, 74,
      :package_replaces, 75,
      :package_provides, 76,
      :package_recommends, 77,
      :package_suggests, 78,
      :package_maintainer, 79,
      :package_installed_size, 80,
      :package_source, 81,
      :package_essential, 82,
      :target_architecture, 83,
      :package_pre_dependency, 84,
      :license, 85,
      :package_distribution, 86,
      :buildhost, 87,
      :vendor, 88,
      :target_os, 89,
      :software_version, 90,
      :target_platform, 91,
      :resource_type, 92,
      :library_search_path, 93,
      :library_dependency, 94,

      # photography specifics
      :camera_make, 95,
      :camera_model, 96,
      :exposure, 97,
      :aperture, 98,
      :exposure_bias, 99,
      :flash, 100,
      :flash_bias, 101,
      :focal_length, 102,
      :focal_length_35mm, 103,
      :iso_speed, 104,
      :exposure_mode, 105,
      :metering_mode, 106,
      :macro_mode, 107,
      :image_quality, 108,
      :white_balance, 109,
      :orientation, 110,
      :magnification, 111,

      # image specifics
      :image_dimensions, 112, 
      :produced_by_software, 113, 
      :thumbnail, 114,
      :image_resolution, 115,
      :source, 116,

      # (text) document processing specifics
      :character_set, 117,
      :line_count, 118,
      :paragraph_count, 119,
      :word_count, 120,
      :character_count, 121,
      :page_orientation, 122,
      :paper_size, 123,
      :template, 124,
      :company, 125,
      :manager, 126,
      :revision_number, 127,

      # music / video specifics
      :duration, 128,
      :album, 129,
      :artist, 130,
      :genre, 131,
      :track_number, 132,
      :disc_number, 133,
      :performer, 134,
      :contact_information, 135,
      :song_version, 136,
      :picture, 137,
      :cover_picture, 138,
      :contributor_picture, 139,
      :event_picture, 140,
      :logo, 141,
      :broadcast_television_system, 142,
      :source_device, 143,
      :disclaimer, 144,
      :warning, 145,
      :page_order, 146,
      :writer, 147,
      :product_version, 148,
      :contributor_name, 149,
      :movie_director, 150,
      :network_name, 151,
      :show_name, 152,
      :chapter_name, 153,
      :song_count, 154,
      :starting_song, 155,
      :play_counter, 156,
      :conductor, 157,
      :interpretation, 158,
      :composer, 159,
      :beats_per_minute, 160,
      :encoded_by, 161,
      :original_title, 162,
      :original_artist, 163,
      :original_writer, 164,
      :original_release_year, 165,
      :original_performer, 166,
      :lyrics, 167,
      :popularity_meter, 168,
      :licensee, 169,
      :musician_credits_list, 170,
      :mood, 171, 
      :subtitle, 172, 

      # GNUnet specific values (never extracted)
      :gnunet_display_type, 173,
      :gnunet_full_data, 174,
      :rating, 175,
      :organization, 176,
      :ripper, 177,
      :producer, 178,
      :group, 179,

      :last, 180
    ]

    callback :extractor_meta_data_processor, [:pointer, :string, :extractor_meta_type, :extractor_meta_format, :string, :string, :size_t], :int

    callback :extractor_extract_method, [:string, :size_t, :extractor_meta_data_processor, :pointer, :string], :int

    typedef :pointer, :extractor_plugin_list

  end
end
