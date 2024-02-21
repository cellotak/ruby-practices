# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/parent_directory'
require_relative '../libs/child_entry'


class ParentDirectoryTest < Minitest::Test

  def setup
    Dir.mkdir('test_directory')
    Dir.mkdir('test_directory/child_directory')
    File.open('test_directory/hoge1.txt', 'w') {}
  end

  def teardown
    File.delete('test_directory/hoge1.txt') if File.exist?('test_directory/hoge1.txt')
    Dir.rmdir('test_directory/child_directory') if Dir.exist?('test_directory/child_directory')
    Dir.rmdir('test_directory') if Dir.exist?('test_directory')
  end

  def test_parent_directory_initialize
    parent_directory = ParentDirectory.new('test_directory')
    assert_equal 'test_directory', parent_directory.directory_path
    child_entry_stat = ChildEntry.new('hoge1.txt','test_directory').stat
    assert_equal 2, parent_directory.child_entries.count
    assert_equal child_entry_stat, parent_directory.child_entries[0].stat
  end

  def test_total_blocks
    parent_directory = ParentDirectory.new('test_directory')
    assert_equal 8, parent_directory.total_blocks
  end
end
