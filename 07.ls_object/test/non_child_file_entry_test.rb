# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/non_child_file_entry'

class EntryTest < Minitest::Test

  def setup
    Dir.mkdir('test_directory')
    File.open('test_directory/hoge1.txt', 'w') {}
  end

  def teardown
    File.delete('test_directory/hoge1.txt') if File.exist?('test_directory/hoge1.txt')
    Dir.rmdir('test_directory') if Dir.exist?('test_directory')
  end

  def test_entry_intialize
    entry = NonChildFileEntry.new('test_directory/hoge1.txt')
    assert_equal 'test_directory/hoge1.txt', entry.specified_path
    assert_equal 'hoge1.txt', entry.basename
    assert_equal 'test_directory', entry.dirname
    assert_equal 4096, entry.stat.blksize
    assert_equal 1000, entry.stat.uid
  end

  def test_path
    entry = NonChildFileEntry.new('test_directory/hoge1.txt')
    assert_equal 'test_directory/hoge1.txt', entry.path
  end
end
