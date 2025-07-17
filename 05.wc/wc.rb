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

  file_paths.each do |file_path|
    process_file(file_path)
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

def process_file(file_path)
  puts "Processing file: #{file_path}"

  unless File.exist?(file_path)
    puts "wc: #{file_path}: No such file or directory"
    return
  end

  if File.directory?(file_path)
    puts "wc: #{file_path}: Is a directory"
    return
  end

  content = File.read(file_path)
  puts "File.read(file_path).inspect = #{content.inspect}"
end

main
