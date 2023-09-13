#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COL_COUNT = 3
SPACE_WIDTH = 2

FILE_TYPE_LIST = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze

# directory_pathsには複数のpathを指定することは許容しているが、現時点でファイル名を表示するのは1番目に指定したディレクトリのみにしている。
def main
  options, directory_paths = parse_options(ARGV)
  target_directory_path = directory_paths[0] || './'
  file_names = fetch_file_names(target_directory_path, options)
  output(file_names, target_directory_path, options)
end

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  directory_paths = opt.parse(argv)
  [options, directory_paths]
end

def fetch_file_names(target_directory_path, options)
  dotmatch_flag = options[:a] ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', dotmatch_flag, base: target_directory_path)

  options[:r] ? file_names.reverse : file_names
end

def output(file_names, target_directory_path, options)
  return if file_names.empty?

  if options[:l]
    output_long_listing_format(file_names, target_directory_path)
  else
    output_default_format(file_names)
  end
end

def output_long_listing_format(file_names, target_directory_path)
  block_count_total = 0

  details_list = {}
  details_size = 0

  file_names.each do |file_name|
    stat = File.stat("#{target_directory_path}/#{file_name}")
    details = []
    details << "#{convert_stat_mode_to_str(stat.mode)}"
    details << "#{stat.nlink}"
    details << "#{Etc.getpwuid(stat.uid).name}"
    details << "#{Etc.getgrgid(stat.gid).name}"
    details << "#{stat.size}"
    details << "#{stat.ctime.strftime('%b')}"
    details << "#{stat.ctime.strftime('%-d')}"
    details << "#{stat.ctime.strftime('%H:%M')}"
    details << "#{file_name}"
    block_count_total += stat.blocks
    details_size = details.size
    details_list["#{file_name}"] = details
  end

  widths = []
  details_size.times do |index|
    lengths = details_list.map{|file_name, details| details[index].length}
    widths << lengths.max + 1
  end
  p widths

  puts "total #{block_count_total}"


  file_names.each do |file_name|
    details_size.times do |index| 
      if  /^\d+$/.match("#{details_list["#{file_name}"][index]}")
        print "#{details_list["#{file_name}"][index]} ".rjust(widths[index])
      else
        print "#{details_list["#{file_name}"][index]}".ljust(widths[index])
      end
    end
    print "\n"
  end

end

def output_default_format(file_names)
  row_count = ((file_names.size - 1) / MAX_COL_COUNT) + 1
  col_count = [file_names.size, MAX_COL_COUNT].min

  # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
  # NOTE: file_names_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されている
  file_names_table = file_names.each_slice(row_count).to_a
  widths = file_names_table.map { |col| col.map(&:size).max + SPACE_WIDTH }

  row_count.times do |row_index|
    col_count.times do |col_index|
      # file_names_tableの行と列が逆で保存されているので、col_indexとrow_indexを入れ替えて出力させている
      target_file_name = file_names_table[col_index][row_index]
      print target_file_name&.ljust(widths[col_index])
    end
    print "\n"
  end
end

def convert_stat_mode_to_str(stat_mode)
  file_type_code = format('%06o', stat_mode).slice(0..1)
  file_type_char = FILE_TYPE_LIST[file_type_code]

  permission_code = format('%06o', stat_mode).slice(3..5)
  permission_str = convert_permission_code_to_str(permission_code)

  file_type_char + permission_str
end

def convert_permission_code_to_str(permission_code)
  permission_code_nums = permission_code.chars.map(&:to_i)
  permission_octets = permission_code_nums.map do |num|
    permission_octet_chars = []

    permission_octet_chars << (num / 4 == 1 ? 'r' : '-')
    permission_octet_chars << ((num / 2).odd? ? 'w' : '-')
    permission_octet_chars << (num.odd? ? 'x' : '-')

    permission_octet_chars.join
  end
  permission_octets.join
end

main
