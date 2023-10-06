#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COL_COUNT = 3
SPACE_WIDTH = 2

FILE_TYPE_LIST = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze

def main
  options, directory_paths = parse_options(ARGV)
  # directory_pathsには複数のpathを指定することは許容しているが、現時点でファイル名を表示するのは1番目に指定したディレクトリのみにしている。
  directory_path = directory_paths[0] || './'
  file_names = fetch_file_names(directory_path, options)
  output(file_names, directory_path, options)
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

def fetch_file_names(directory_path, options)
  dotmatch_flag = options[:a] ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', dotmatch_flag, base: directory_path)

  options[:r] ? file_names.reverse : file_names
end

def output(file_names, directory_path, options)
  return if file_names.empty?

  if options[:l]
    output_long_listing_format(file_names, directory_path)
  else
    output_default_format(file_names)
  end
end

def output_long_listing_format(file_names, directory_path)
  puts "total #{calc_block_count_total(file_names, directory_path)}"

  details_by_file_name = build_details_by_file_name(file_names, directory_path)

  file_names.each do |file_name|
    details = details_by_file_name[file_name]
    details_output_order = %i[stat_mode nlink username groupname size ctime]

    details_output_order.each do |key|
      width = calc_max_width_by_detail(details_by_file_name, key)
      if /^\d+$/.match?(details[key])
        print details[key].rjust(width)
      else
        print details[key].ljust(width)
      end
      print ' '
    end
    puts file_name
  end
end

def calc_block_count_total(file_names, directory_path)
  file_names.map do |file_name| 
    file_path = "#{directory_path}/#{file_name}"
    File.stat(file_path).blocks
  end.sum
end

def build_details_by_file_name(file_names, directory_path)
  details_by_file_name = {}
  file_names.each do |file_name|
    stat = File.stat("#{directory_path}/#{file_name}")
    details = convert_stat_to_details(stat)
    details_by_file_name[file_name] = details
  end
  details_by_file_name
end

def convert_stat_to_details(stat)
  details = {}
  details[:stat_mode] = convert_stat_mode_to_str(stat.mode)
  details[:nlink] = stat.nlink.to_s
  details[:username] = Etc.getpwuid(stat.uid).name
  details[:groupname] = Etc.getgrgid(stat.gid).name
  details[:size] = stat.size.to_s
  details[:ctime] = stat.ctime.strftime('%b %e %H:%M')
  details
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

def calc_max_width_by_detail(details_by_file_name, key)
  detail_widths_by_file_name = details_by_file_name.map { |_file_name, details| details[key].length }
  detail_widths_by_file_name.max
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

main
