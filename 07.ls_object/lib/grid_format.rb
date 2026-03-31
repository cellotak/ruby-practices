# frozen_string_literal: true

class GridFormat
  # OS標準のlsコマンドでは画面幅によって列数が変わるが、本lsコマンドでは現状列数はデフォルト引数の値に固定している。
  def initialize(col_count: 3, space_width: 2)
    @col_count = col_count
    @space_width = space_width
  end

  def output(entry_list)
    entries = entry_list.entries
    return '' if entries.empty?

    row_count = ((entries.size - 1) / @col_count) + 1
    entries_table = entries.each_slice(row_count).to_a
    widths = entries_table.map { |col| col.map { |entry| display_width(entry.name) }.max + @space_width }

    # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
    last_col = entries_table.last
    empty_cell_count = row_count - last_col.size
    last_col.fill(nil, last_col.size, empty_cell_count)
    rows = entries_table.transpose

    rows.map { |row_entries| build_line(row_entries, widths) }.join("\n")
  end

  private

  # @param row_entries [Array<Entry, nil>] その行に表示するEntryの配列 (例: [Entry(a), Entry(c), Entry(e)])
  # @param widths [Array<Integer>] 各列の幅の配列 (例: [12, 15, 10])
  def build_line(row_entries, widths)
    row_entries.zip(widths)
               .filter_map do |entry, width|
                 next unless entry

                 # マルチバイト文字対応のため表示幅(width)に合わせてパディングを計算している
                 padding = width - display_width(entry.name)
                 entry.name.ljust(entry.name.length + padding)
               end
               .join
               .rstrip
  end

  def display_width(str)
    str.to_s.chars.sum { |char| char.ascii_only? ? 1 : 2 }
  end
end
