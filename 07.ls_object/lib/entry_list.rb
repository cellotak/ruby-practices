# frozen_string_literal: true

class EntryList
  include Enumerable

  DETAIL_KEYS = %i[mode_string nlink owner group filesize mtime_string name].freeze

  def initialize(entries)
    @entries = entries
  end

  def each(&block)
    @entries.each(&block)
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
