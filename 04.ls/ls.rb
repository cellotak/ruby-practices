#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COL_COUNT = 3
SPACE_WIDTH = 2

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  directory_paths = opt.parse(argv)
  [options, directory_paths]
end

def fetch_file_details(target_directory_path, options)
  dotmatch_flag = options[:a] ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', dotmatch_flag, base: target_directory_path)
  file_details = file_names.map { |filename| { name: filename } }

  if options[:l]
    file_details.each do |file_detail|
      stat = File.stat("#{target_directory_path}/#{file_detail[:name]}")
      file_detail[:mode] = stat.mode # 要変換
      file_detail[:hardlink_count] = stat.nlink
      file_detail[:owner_user] = stat.uid # 要変換
      file_detail[:owner_group] = stat.gid # 要変換
      file_detail[:size] = stat.size
      file_detail[:ctime] = stat.ctime
    end
  end

  options[:r] ? file_details.reverse : file_details
end

def output(file_details, options)
  return if file_details.empty?

  if options[:l]
    file_details.each do |file_detail|
      detail_str = 
        "#{file_detail[:mode]} "\
        "#{file_detail[:hardlink_count]} "\
        "#{file_detail[:owner_user]} "\
        "#{file_detail[:owner_group]} "\
        "#{file_detail[:size]} "\
        "#{file_detail[:ctime]} "\
        "#{file_detail[:name]}"
      puts detail_str
    end

  else
    row_count = ((file_details.size - 1) / MAX_COL_COUNT) + 1
    col_count = [file_details.size, MAX_COL_COUNT].min

    # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
    # NOTE: file_names_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されている
    file_details_table = file_details.each_slice(row_count).to_a
    widths = file_details_table.map { |col| col.map{|detail| detail[:name].size}.max + SPACE_WIDTH }

    row_count.times do |row_index|
      col_count.times do |col_index|
        # file_names_tableの行と列が逆で保存されているので、col_indexとrow_indexを入れ替えて出力させている
        target_file_detail = file_details_table[col_index][row_index]
        print target_file_detail[:name].ljust(widths[col_index]) unless target_file_detail.nil? # 要修正
      end
      print "\n"
    end
  end
    
end

# directory_pathsには複数のpathを指定することは許容しているが、現時点でファイル名を表示するのは1番目に指定したディレクトリのみにしている。
options, directory_paths = parse_options(ARGV)
directory_path = directory_paths[0] || './'
file_details = fetch_file_details(directory_path, options)
output(file_details, options)
