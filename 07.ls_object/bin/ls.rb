#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/options'
require_relative '../lib/entry'
require_relative '../lib/entry_list'
require_relative '../lib/long_formatter'
require_relative '../lib/default_formatter'

def main
  options = Options.new(ARGV)
  formatter = options.long_format? ? LongFormatter.new : DefaultFormatter.new
  paths = options.paths.empty? ? ['.'] : options.paths

  files = []
  dirs = []

  sorted_paths = options.reverse? ? paths.sort.reverse : paths.sort

  sorted_paths.each do |path|
    if File.file?(path)
      files << path
    elsif File.directory?(path)
      dirs << path
    elsif !File.exist?(path)
      warn "ls: cannot access '#{path}': No such file or directory"
    end
  end

  if files.any?
    list = EntryList.generate_from_files(files)
    output = formatter.format(list)
    puts output unless output.empty?
  end

  puts if !files.empty? && !dirs.empty?

  dirs.each_with_index do |dir_path, index|
    puts "#{dir_path}:" if paths.size > 1

    list = EntryList.generate_from_directory(dir_path, options)
    output = formatter.format(list)
    puts output unless output.empty?

    puts if index < dirs.size - 1
  end
end

main
