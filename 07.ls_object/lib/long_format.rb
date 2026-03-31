# frozen_string_literal: true

class LongFormat
  COLUMN_ORDER_AND_ALIGNMENTS = {
    mode_string: :left,
    nlink: :right,
    owner: :left,
    group: :left,
    filesize: :right,
    mtime_string: :left,
    name: :left
  }.freeze

  def output(entry_list)
    widths = entry_list.max_widths

    lines = entry_list.entries.map { |entry| build_line(entry, widths) }
    lines.unshift("total #{entry_list.total_blocks}") if entry_list.total_needed?

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
