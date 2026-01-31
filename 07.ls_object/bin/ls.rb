#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/options'
require_relative '../lib/entry'
require_relative '../lib/entry_list'
require_relative '../lib/long_formatter'
require_relative '../lib/default_formatter'

options = Options.new(ARGV)

target_paths = options.paths.empty? ? ['.'] : options.paths

target_files = []
target_dirs = []

sorted_paths = options.reverse? ? target_paths.sort.reverse : target_paths.sort

sorted_paths.each do |path|
  if File.file?(path)
    target_files << path
  elsif File.directory?(path)
    target_dirs << path
  elsif !File.exist?(path)
    warn "ls: cannot access '#{path}': No such file or directory"
  end
end

if target_files.any?
  entries = target_files.map do |path|
    Entry.new(File.dirname(path), File.basename(path))
  end

  list = EntryList.new(entries)

  if options.long_format?
    LongFormatter.new.format(list)
  else
    DefaultFormatter.new.format(list)
  end
end

puts if !target_files.empty? && !target_dirs.empty?

target_dirs.each_with_index do |dir_path, index|
  puts "#{dir_path}:" if target_paths.size > 1

  filenames = options.reverse? ? Dir.entries(dir_path).sort.reverse : Dir.entries(dir_path).sort

  filenames.reject! { |name| name.start_with?('.') } unless options.all?

  entries = filenames.map { |name| Entry.new(dir_path, name) }
  list = EntryList.new(entries)

  if options.long_format?
    LongFormatter.new.format(list)
  else
    DefaultFormatter.new.format(list)
  end

  puts if index < target_dirs.size - 1
end
