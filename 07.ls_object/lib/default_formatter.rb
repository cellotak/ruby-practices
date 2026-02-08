# frozen_string_literal: true

class DefaultFormatter
  # OS標準のlsコマンドでは画面幅によって列数が変わるが、本lsコマンドでは列数を固定にしている
  MAX_COL_COUNT = 3
  SPACE_WIDTH = 2

  def format(entry_list)
    entries = entry_list.entries
    return '' if entries.empty?

    row_count = ((entries.size - 1) / MAX_COL_COUNT) + 1
    col_count = [entries.size, MAX_COL_COUNT].min

    entries_table = entries.each_slice(row_count).to_a

    widths = entries_table.map { |col| col.map { |entry| display_width(entry.name) }.max + SPACE_WIDTH }

    # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
    # 一方entries_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されているためcol_indexとrow_indexを入れ替えてformatしている
    Array.new(row_count) do |row_index|
      row_entries = Array.new(col_count) { |col_index| entries_table.dig(col_index, row_index) }

      build_line(row_entries, widths)
    end.join("\n")
  end

  private

  # @param row_entries [Array<Entry, nil>] その行に表示するEntryの配列 (例: [Entry(a), Entry(c), Entry(e)])
  # @param widths [Array<Integer>] 各列の幅の配列 (例: [12, 15, 10])
  def build_line(row_entries, widths)
    row_entries.zip(widths)
               .filter_map do |entry, width|
                 next unless entry

                 padding = width - display_width(entry.name)
                 "#{entry.name}#{' ' * padding}"
               end
               .join
               .rstrip
  end

  def display_width(str)
    str.to_s.chars.sum { |char| char.ascii_only? ? 1 : 2 }
  end
end
