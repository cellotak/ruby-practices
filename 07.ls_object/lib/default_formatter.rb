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

    widths = entries_table.map { |col| col.map { |entry| entry.name.length }.max + SPACE_WIDTH }

    # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
    # 一方entries_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されているためcol_indexとrow_indexを入れ替えてformatしている
    row_count.times.map do |row_index|
      row_entries = col_count.times.map { |col_index| entries_table.dig(col_index, row_index) }

      build_line(row_entries, widths)
    end.join("\n")
  end

  private

  def build_line(row_entries, widths)
    line = +''

    row_entries.each_with_index do |entry, col_index|
      line << entry.name.ljust(widths[col_index]) if entry
    end

    line.rstrip
  end
end
