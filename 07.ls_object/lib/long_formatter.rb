# frozen_string_literal: true

class LongFormatter
  COLUMN_ORDER_AND_ALIGNMENTS = {
    mode_string: :left,
    nlink: :right,
    owner: :left,
    group: :left,
    filesize: :right,
    mtime_string: :left,
    name: :left
  }.freeze

  def format(entry_list)
    lines = []
    lines << "total #{entry_list.total_blocks}" if entry_list.total_needed?

    widths = entry_list.max_widths

    entry_list.entries.each do |entry|
      lines << build_line(entry, widths)
    end

    lines.join("\n")
  end

  private

  def build_line(entry, widths)
    COLUMN_ORDER_AND_ALIGNMENTS.map do |key, align|
      value = entry.send(key).to_s
      width = widths[key]

      format_value(value, width, align)
    end.join(' ')
  end

  def format_value(value, width, align)
    align == :right ? value.rjust(width) : value.ljust(width)
  end
end
