# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../libs/entry'

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
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal 'hoge1.txt', entry.basename
    assert_equal 'test_directory', entry.dirname
    assert_equal 4096, entry.stat.blksize
    assert_equal 1000, entry.stat.uid
  end

  def test_path
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal 'test_directory/hoge1.txt', entry.path
  end

  def test_stat_mode
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal '-rw-r--r--', entry.stat_mode
  end

  def test_nlink
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal '1', entry.nlink 
  end

  def test_username
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal 'cellotak', entry.username
  end

  def test_groupname
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal 'cellotak', entry.groupname
  end

  def test_size
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal '0', entry.size
  end

  def test_ctime
    entry = Entry.new('hoge1.txt', 'test_directory')
  end

  def test_blocks
    entry = Entry.new('hoge1.txt', 'test_directory')
    assert_equal 0, entry.blocks
  end

  def test_details
    entry = Entry.new('hoge1.txt', 'test_directory')
    details = { 
      filename: entry.basename,
      stat_mode: entry.stat_mode,
      username: entry.username,
      groupname: entry.groupname,
      size: entry.size,
      ctime: entry.ctime
    }

    assert_equal details, entry.details
  end
end
