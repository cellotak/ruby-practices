# frozen_string_literal: true

class EntryList
  attr_reader :entries

  DETAIL_KEYS = %i[mode_string nlink owner group filesize mtime_string name].freeze

  def initialize(entries)
    @entries = entries
  end

  def self.generate_from_directory(dir_path, options)
    filenames = Dir.entries(dir_path).sort

    filenames = options.reverse? ? filenames.reverse : filenames

    filenames.reject! { |name| name.start_with?('.') } unless options.all?

    entries = filenames.map { |name| Entry.new(dir_path, name) }

    new(entries)
  end

  def self.generate_from_files(file_paths)
    entries = file_paths.map do |path|
      Entry.new(File.dirname(path), File.basename(path))
    end
    new(entries)
  end

  def total_blocks
    @entries.sum(&:blocks)
  end

  def max_widths
    DETAIL_KEYS.to_h do |key|
      width = @entries.map { |entry| display_width(entry.send(key)) }.max || 0
      [key, width]
    end
  end

  private

  def display_width(str)
    str.to_s.chars.sum { |char| char.bytesize == 1 ? 1 : 2 }
  end
end
