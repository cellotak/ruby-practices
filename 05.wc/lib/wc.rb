#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, file_paths = parse_options(ARGV)

  # パイプで接続した場合 $stdin.tty? は false になる
  stats_list, total_stats = (file_paths.empty? && !$stdin.tty?) ? collect_stdin_stats : collect_file_stats(file_paths)

  max_width = calculate_max_width(stats_list, total_stats)

  stats_list.each { |stats| output_format(stats, options, max_width) }

  output_format(total_stats, options, max_width) if stats_list.size > 1
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

def collect_stdin_stats
  stdin_stats = build_stats($stdin.read)
  stdin_stats[:file_path] = nil
  stdin_stats_list = [stdin_stats]
  total_stats = nil

  [stdin_stats_list, total_stats]
end

def collect_file_stats(file_paths)
  file_stats_list = []
  total_stats = { lines: 0, words: 0, bytes: 0, file_path: 'total' }

  file_paths.each do |file_path|
    file_stats = read_and_count_file(file_path)
    next unless file_stats

    file_stats_list << file_stats

    total_stats[:lines] += file_stats[:lines]
    total_stats[:words] += file_stats[:words]
    total_stats[:bytes] += file_stats[:bytes]
  end

  total_stats = nil if file_stats_list.size <= 1

  [file_stats_list, total_stats]
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
  build_stats(content, file_path)
end

def build_stats(content, file_path = nil)
  {
    lines: content.count("\n"),
    words: content.split.size,
    bytes: content.bytesize,
    file_path: file_path
  }
end

def calculate_max_width(stats_list, total_stats)
  return if stats_list.empty?

  # 表示されるかどうかにかかわらず、statsのうち最大幅となるものに合わせて右揃えする仕様にしている。
  # 3つのstatsのうちbytesが必ず最大幅となる。複数ファイルの場合はtotalのbytesが最大、単一ファイルの場合はそのファイルのbytesが最大となる。
  stat = stats_list.size > 1 ? total_stats : stats_list.first
  stat[:bytes].to_s.length
end

def output_format(stats, options, max_width)
  columns = %i[lines words bytes].map do |key|
    stats[key].to_s.rjust(max_width) if options[key] || options.empty?
  end

  # パイプで接続した場合、stats[:file_path] は nil になるため、file_pathは出力しない
  columns << stats[:file_path]
  puts columns.compact.join(' ')
end

main
