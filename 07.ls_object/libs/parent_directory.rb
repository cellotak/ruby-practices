# frozen_string_literal: true

require_relative '../libs/child_entry'

class ParentDirectory
  attr_reader :directory_path, :child_entries

  def initialize(directory_path)
    @directory_path = directory_path
    @child_entries = Dir.glob('*', base: directory_path).map{ |entry_path| ChildEntry.new(entry_path, directory_path)}
  end

  def total_blocks
    @child_entries.map(&:blocks).sum
  end
end
