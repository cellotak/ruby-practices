# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/child_entry'

class ChildEntryTest < Minitest::Test

  def setup
    Dir.mkdir('test_directory')
    File.open('test_directory/hoge1.txt', 'w') {}
  end

  def teardown
    File.delete('test_directory/hoge1.txt') if File.exist?('test_directory/hoge1.txt')
    Dir.rmdir('test_directory') if Dir.exist?('test_directory')
  end

  def test_child_entry_intialize
    entry = ChildEntry.new('hoge1.txt', 'test_directory')
    assert_equal 'hoge1.txt', entry.basename
    assert_equal 'test_directory', entry.dirname
    assert_equal 4096, entry.stat.blksize
    assert_equal 1000, entry.stat.uid
  end
end
