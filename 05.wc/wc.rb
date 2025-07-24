#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, file_paths = parse_options(ARGV)

  # パイプで接続した場合 STDIN.tty? は false になる
  if file_paths.empty? && !STDIN.tty?
    stdin_content = STDIN.read
    file_paths = parse_ls_output(stdin_content)
  end

  total_stats = { lines: 0, words: 0, bytes: 0 }
  file_stats_list = []

  file_paths.each do |file_path|
    file_stats = read_and_count_file(file_path)
    if file_stats
      file_stats_list << { stats: file_stats, path: file_path }
      total_stats[:lines] += file_stats[:lines]
      total_stats[:words] += file_stats[:words]
      total_stats[:bytes] += file_stats[:bytes]
    end
  end

  file_stats_list.each do |file_data|
    output_format(file_data[:stats], options, file_data[:path])
  end

  if file_stats_list.size > 1
    output_format(total_stats, options, "total")
  end
end

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  file_paths = opt.parse(argv)
  [options, file_paths]
end

def parse_ls_output(content)
  lines = content.strip.split("\n")
  file_paths = []

  lines.each do |line|
    next if line.start_with?('total')

    filename = line.split[8]
    # 本家lsコマンドだとファイル名に色コードが含まれている場合があるためその対応
    filename = filename.gsub(/\e\[[0-9;]*m/, '')
    next if filename == '.' || filename == '..'

    file_paths << filename
  end

  file_paths
end

def read_and_count_file(file_path)
  unless File.exist?(file_path)
    puts "wc: #{file_path}: No such file or directory"
    return nil
  end

  if File.directory?(file_path)
    puts "wc: #{file_path}: Is a directory"
    return nil
  end

  content = File.read(file_path)
  count_content(content)
end

def count_content(content)
  lines = content.count("\n")
  words = content.split.size
  bytes = content.bytesize

  {
    lines: lines,
    words: words,
    bytes: bytes
  }
end

def output_format(count_stats, options, file_path)
  output = []

  if options.empty?
    output << count_stats[:lines].to_s.rjust(2)
    output << count_stats[:words].to_s.rjust(2)
    output << count_stats[:bytes].to_s.rjust(2)
  else
    output << count_stats[:lines].to_s.rjust(2) if options[:l]
    output << count_stats[:words].to_s.rjust(2) if options[:w]
    output << count_stats[:bytes].to_s.rjust(2) if options[:c]
  end

  output << file_path
  puts output.join(' ')
end

main
