#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# MAX_COL_COUNT = 3
# SPACE_WIDTH = 2

# FILE_TYPE_LIST = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
# DETAILS_OUTPUT_ORDER = %i[stat_mode nlink username groupname size ctime].freeze
# RJUST_LIST = %i[nlink size].freeze

def main
  puts "ARGV: #{ARGV}"
  p "ARGV: #{ARGV.inspect}"
  options, file_paths = parse_options(ARGV)

  # パイプからの入力を処理
  if file_paths.empty? && !STDIN.tty?
    # 標準入力がパイプの場合
    stdin_content = STDIN.read
    # 改行で分割してファイルパスのリストを作成
    # file_paths = stdin_content.strip.split("\n").reject(&:empty?)
    file_paths = parse_ls_output(stdin_content)
  end

  file_paths.each do |file_path|
    puts "Processing file: #{file_path}"
  end

  puts "Options: #{options.inspect}"
  puts "options[:l] = #{options[:l].inspect}" if options[:l]
  puts "options[:w] = #{options[:w].inspect}" if options[:w]
  puts "options[:c] = #{options[:c].inspect}" if options[:c]
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

    parts = line.split
    filename = parts[8]

    filename = filename.split('->').first if filename.include?('->')

    file_paths << filename unless filename == '.' || filename == '..'
  end

  file_paths
end

main
