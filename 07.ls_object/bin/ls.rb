#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/options'
require_relative '../lib/entry'
require_relative '../lib/entry_list'
require_relative '../lib/long_formatter'
require_relative '../lib/default_formatter'

options = Options.new(ARGV)

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

  if options.long_format?
    LongFormatter.new.format(list)
  else
    DefaultFormatter.new.format(list)
  end
end

puts if !files.empty? && !dirs.empty?

dirs.each_with_index do |dir_path, index|
  puts "#{dir_path}:" if paths.size > 1
  puts "#{dir_path}:" if paths.size > 1

  list = EntryList.generate_from_directory(dir_path, options)

  if options.long_format?
    LongFormatter.new.format(list)
  else
    DefaultFormatter.new.format(list)
  end

  puts if index < dirs.size - 1
end
