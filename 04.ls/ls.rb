#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COL_COUNT = 3
SPACE_WIDTH = 2

FILE_TYPES = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
DETAILS_KEYS = { stat_mode: :left, nlink: :right, username: :left, groupname: :left, size: :right, ctime: :left, file_name: :left }.freeze

def main
  options, paths = parse_options(ARGV)
  # pathsには複数のpathを指定することは許容しているが、ファイル名を表示するのは1番目に指定したディレクトリorファイルのみにしている。
  path = paths[0] || './'
  if File.directory?(path)
    file_names = fetch_file_names(path, options)
    output(file_names, path, options)
  else
    file_path = File.basename(path)
    file_names = [file_path]
    directory_path = File.dirname(path)
    output(file_names, directory_path, options)
  end
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
  details_by_file_name = build_details_by_file_name(file_names, directory_path)

  puts "total #{calc_block_count_total(details_by_file_name)}"

  max_width_by_detail = calc_max_width_by_detail(details_by_file_name)

  details_by_file_name.each do |details|
    DETAILS_KEYS.each do |key, align|
      value = details[key]
      width = max_width_by_detail[key]
      print(align == :right ? value.rjust(width) : value.ljust(width))
      print ' '
    end
    print "\n"
  end
end

def calc_block_count_total(details_by_file_name)
  details_by_file_name.sum do |details|
    details[:blocks]
  end
end

def build_details_by_file_name(file_names, directory_path)
  file_names.map do |file_name|
    stat = File.stat("#{directory_path}/#{file_name}")
    details = convert_stat_to_details(stat)
    details[:file_name] = file_name
    details
  end
end

def convert_stat_to_details(stat)
  {
    stat_mode: convert_stat_mode_to_str(stat.mode),
    nlink: stat.nlink.to_s,
    username: Etc.getpwuid(stat.uid).name,
    groupname: Etc.getgrgid(stat.gid).name,
    size: stat.size.to_s,
    ctime: stat.ctime.strftime('%b %e %H:%M'),
    blocks: stat.blocks
  }
end

def convert_stat_mode_to_str(stat_mode)
  file_type_code = format('%06o', stat_mode).slice(0..1)
  file_type_char = FILE_TYPES[file_type_code]

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

def calc_max_width_by_detail(details_by_file_name)
  DETAILS_KEYS.to_h do |key|
    widths_by_detail = details_by_file_name.map { |details| calc_display_length(details[key]) }
    [key, widths_by_detail.max]
  end
end

def output_default_format(file_names)
  row_count = ((file_names.size - 1) / MAX_COL_COUNT) + 1
  col_count = [file_names.size, MAX_COL_COUNT].min

  # NOTE: OS標準のlsコマンドは横並びではなく縦並びで出力される(転置して出力される)
  # NOTE: file_names_tableの要素は行と列が出力したい形(縦並び)とは逆で保存されている
  file_names_table = file_names.each_slice(row_count).to_a
  widths = file_names_table.map { |col| col.map { |file_name| calc_display_length(file_name) }.max + SPACE_WIDTH }
  row_count.times do |row_index|
    col_count.times do |col_index|
      # file_names_tableの行と列が逆で保存されているので、col_indexとrow_indexを入れ替えて出力させている
      target_file_name = file_names_table.dig(col_index, row_index)
      print target_file_name&.ljust(widths[col_index]) if target_file_name
    end
    print "\n"
  end
end

def calc_display_length(file_name)
  file_name.chars.sum { |char| char.bytesize == 1 ? 1 : 2 }
end

def ljust_multibyte_chars(ljust_target, width)
  return nil if ljust_target.nil?

  adjusted_width = width - (calc_display_length(ljust_target) - ljust_target.length)
  ljust_target.ljust(adjusted_width)
end

main
