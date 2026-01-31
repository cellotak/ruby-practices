# frozen_string_literal: true

class DefaultFormatter
  # OS標準のlsコマンドでは画面幅によって列数が変わるが、本lsコマンドでは列数を固定にしている
  MAX_COL_COUNT = 3
  SPACE_WIDTH = 2

  def format(entry_list)
    entries = entry_list.to_a
    return if entries.empty?

    row_count = ((entries.size - 1) / MAX_COL_COUNT) + 1
    col_count = [entries.size, MAX_COL_COUNT].min

    entries_table = entries.each_slice(row_count).to_a

    widths = entries_table.map { |col| col.map { |entry| entry.name.length }.max + SPACE_WIDTH }

    # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
    # 一方entries_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されているためcol_indexとrow_indexを入れ替えて出力させている。
    row_count.times do |row_index|
      col_count.times do |col_index|
        target_entry = entries_table.dig(col_index, row_index)
        print target_entry.name.ljust(widths[col_index]) if target_entry
      end
      print "\n"
    end
  end
end
