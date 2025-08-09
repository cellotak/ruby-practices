#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, file_paths = parse_options(argv: ARGV)

  # パイプで接続した場合 $stdin.tty? は false になる
  if file_paths.empty? && !$stdin.tty?
    count_stats = count_content(content: $stdin.read)
    max_width = calculate_max_width(file_info_list: [{ stats: count_stats }], total_stats: nil)

    # file_pathにnilを渡すことで、ファイル名を出力しない
    output_format(count_stats:, options:, file_path: nil, max_width:)
    return
  end

  file_info_list, total_stats = collect_file_stats(file_paths:)

  max_width = calculate_max_width(file_info_list:, total_stats:)

  file_info_list.each do |file_info|
    output_format(count_stats: file_info[:stats], options:, file_path: file_info[:path], max_width:)
  end

  return if file_info_list.size <= 1

  output_format(count_stats: total_stats, options:, file_path: 'total', max_width:)
end

def parse_options(argv:)
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  file_paths = opt.parse(argv)
  [options, file_paths]
end

def count_content(content:)
  lines = content.count("\n")
  words = content.split.size
  bytes = content.bytesize

  {
    lines:,
    words:,
    bytes:
  }
end

def collect_file_stats(file_paths:)
  file_info_list = []
  total_stats = { lines: 0, words: 0, bytes: 0 }

  file_paths.each do |file_path|
    file_stats = read_and_count_file(file_path:)
    next unless file_stats

    file_info_list << { stats: file_stats, path: file_path }
    total_stats[:lines] += file_stats[:lines]
    total_stats[:words] += file_stats[:words]
    total_stats[:bytes] += file_stats[:bytes]
  end

  [file_info_list, total_stats]
end

def read_and_count_file(file_path:)
  unless File.exist?(file_path)
    puts "wc: #{file_path}: No such file or directory"
    return nil
  end

  if File.directory?(file_path)
    puts "wc: #{file_path}: Is a directory"
    return nil
  end

  content = File.read(file_path)
  count_content(content:)
end

def calculate_max_width(file_info_list:, total_stats:)
  all_values = []

  # 各ファイルの統計情報から「すべての」値を収集（オプションに関係なく）
  file_info_list.each do |file_info|
    count_stats = file_info[:stats]
    all_values.concat([count_stats[:lines], count_stats[:words], count_stats[:bytes]])
  end

  all_values.concat([total_stats[:lines], total_stats[:words], total_stats[:bytes]]) if total_stats && file_info_list.size > 1

  all_values.map(&:to_s).map(&:length).max
end

def output_format(count_stats:, options:, file_path:, max_width:)
  output = []
  option_mapping = [%i[l lines], %i[w words], %i[c bytes]]

  option_mapping.each do |option_key, stat_key|
    output << count_stats[stat_key].to_s.rjust(max_width) if options[option_key] || options.empty?
  end

  output << file_path if file_path
  puts output.join(' ')
end

main
