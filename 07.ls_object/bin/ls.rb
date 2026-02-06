#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/options'
require_relative '../lib/entry'
require_relative '../lib/entry_list'

def main
  options = Options.new(ARGV)
  formatter = options.formatter
  paths = options.paths.empty? ? ['.'] : options.paths

  files, dirs = separate_paths(paths, options)

  output_files(files, formatter)
  output_blank_line_as_separator(files, dirs)

  should_print_header = paths.size > 1
  output_directories(dirs, formatter, options, should_print_header)
end

def separate_paths(paths, options)
  files = []
  dirs = []

  sorted_paths = options.sort(paths)

  sorted_paths.each do |path|
    if File.file?(path)
      files << path
    elsif File.directory?(path)
      dirs << path
    elsif !File.exist?(path)
      warn "ls: cannot access '#{path}': No such file or directory"
    end
  end

  [files, dirs]
end

def output_files(files, formatter)
  return if files.empty?

  list = EntryList.generate_from_files(files)
  output = formatter.format(list)
  puts output unless output.empty?
end

def output_blank_line_as_separator(files, dirs)
  puts if !files.empty? && !dirs.empty?
end

def output_directories(dirs, formatter, options, print_header)
  dirs.each_with_index do |dir_path, index|
    puts "#{dir_path}:" if print_header

    list = EntryList.generate_from_directory(dir_path, options)
    output = formatter.format(list)
    puts output unless output.empty?

    puts if index < dirs.size - 1
  end
end

main
