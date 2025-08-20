#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, file_paths = parse_options(ARGV)

  # パイプで接続した場合 $stdin.tty? は false になる
  if file_paths.empty? && !$stdin.tty?
    file_stats = count_content($stdin.read)
    file_stats[:file_path] = nil
    file_stats_list = [file_stats]
    total_stats = nil
  else
    file_stats_list, total_stats = collect_file_stats(file_paths)
  end

  max_width = calculate_max_width(file_stats_list, total_stats)

  file_stats_list.each { |stats| output_format(stats, options, max_width) }

  output_format(total_stats, options, max_width) if total_stats
end

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |v| options[:lines] = v }
  opt.on('-w') { |v| options[:words] = v }
  opt.on('-c') { |v| options[:bytes] = v }
  file_paths = opt.parse(argv)
  [options, file_paths]
end

def count_content(content)
  {
    lines: content.count("\n"),
    words: content.split.size,
    bytes: content.bytesize
  }
end

def collect_file_stats(file_paths)
  file_info_list = []
  total_stats = { lines: 0, words: 0, bytes: 0, file_path: 'total' }

  file_paths.each do |file_path|
    file_stats = read_and_count_file(file_path)
    next unless file_stats

    file_stats[:file_path] = file_path
    file_info_list << file_stats

    total_stats[:lines] += file_stats[:lines]
    total_stats[:words] += file_stats[:words]
    total_stats[:bytes] += file_stats[:bytes]
  end

  total_stats = nil if file_info_list.size <= 1

  [file_info_list, total_stats]
end

def read_and_count_file(file_path)
  if !File.exist?(file_path)
    warn "wc: #{file_path}: No such file or directory"
    return
  elsif File.directory?(file_path)
    warn "wc: #{file_path}: Is a directory"
    return
  end

  content = File.read(file_path)
  count_content(content)
end

def calculate_max_width(file_stats_list, total_stats)
  return if file_stats_list.empty?

  # 表示されるかどうかにかかわらず、statsのうち最大幅となるものに合わせて右揃えする仕様にしている。
  # 3つのstatsのうちbytesが必ず最大幅となる。複数ファイルの場合はtotalのbytesが最大、単一ファイルの場合はそのファイルのbytesが最大となる。
  if total_stats
    total_stats[:bytes].to_s.length
  else
    file_stats_list.first[:bytes].to_s.length
  end
end

def output_format(file_stats, options, max_width)
  output = %i[lines words bytes].filter_map do |key|
    file_stats[key].to_s.rjust(max_width) if options[key] || options.empty?
  end

  # パイプで接続した場合、file_stats[:file_path] は nil になるため、file_pathは出力しない
  output << file_stats[:file_path] if file_stats[:file_path]
  puts output.join(' ')
end

main
