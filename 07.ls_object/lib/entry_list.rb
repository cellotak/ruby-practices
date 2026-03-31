# frozen_string_literal: true

require_relative 'entry'

class EntryList
  attr_reader :entries

  DETAIL_KEYS = %i[mode_string nlink owner group filesize mtime_string name].freeze

  def initialize(entries, total_needed: true)
    @entries = entries
    @total_needed = total_needed
  end

  def total_needed?
    @total_needed
  end

  def self.generate_from_files(files)
    entries = files.map do |path|
      Entry.new(File.dirname(path), File.basename(path))
    end
    new(entries, total_needed: false)
  end

  def self.generate_from_directory(dir_path, options)
    filenames = prepare_filenames(Dir.entries(dir_path), options)

    entries = filenames.map { Entry.new(dir_path, it) }
    new(entries)
  end

  def self.prepare_filenames(filenames, options)
    filenames = options.select_visible_entries(filenames)
    options.sort(filenames)
  end

  def total_blocks
    @entries.sum(&:blocks) / 2
  end

  def max_widths
    DETAIL_KEYS.to_h do |key|
      width = @entries.map { |entry| display_width(entry.send(key)) }.max || 0
      [key, width]
    end
  end

  private

  def display_width(str)
    str.to_s.chars.sum { |char| char.ascii_only? ? 1 : 2 }
  end
end
