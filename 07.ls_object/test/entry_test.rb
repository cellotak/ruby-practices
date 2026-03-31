# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'etc'
require_relative '../lib/entry'

class EntryTest < Minitest::Test
  FIXTURE_DIR = 'test/fixtures'
  TARGET_FILE = 'dummy.txt'

  def setup
    FileUtils.mkdir_p(FIXTURE_DIR)
    file_path = File.join(FIXTURE_DIR, TARGET_FILE)
    File.write(file_path, 'Hello')
    FileUtils.chmod(0o644, file_path)
    target_time = Time.local(2024, 1, 1, 12, 0, 0)
    File.utime(target_time, target_time, file_path)

    @entry = Entry.new(FIXTURE_DIR, TARGET_FILE)
  end

  def teardown
    FileUtils.rm_rf(FIXTURE_DIR)
  end

  def test_basic_attributes
    assert_equal TARGET_FILE, @entry.name
    assert_equal "#{FIXTURE_DIR}/#{TARGET_FILE}", @entry.path
  end

  def test_strict_stats
    assert_equal '5', @entry.filesize
    assert_equal '-rw-r--r--', @entry.mode_string
  end

  def test_mtime_string
    assert_equal 'Jan  1 12:00', @entry.mtime_string
  end

  def test_ownership
    current_user = Etc.getpwuid(Process.uid).name
    current_group = Etc.getgrgid(Process.gid).name

    assert_equal current_user, @entry.owner
    assert_equal current_group, @entry.group
  end
end
