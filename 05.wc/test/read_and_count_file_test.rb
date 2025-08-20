# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class ReadAndCountFileTest < Minitest::Test
  def setup
    @test_dir = File.join(__dir__, 'fixtures')
  end

  def test_returns_stats
    result = read_and_count_file(File.join(@test_dir, 'file1.txt'))
    expected_path = File.join(@test_dir, 'file1.txt')
    assert_equal({ lines: 2, words: 2, bytes: 12, file_path: expected_path }, result)
  end

  def test_empty_file
    result = read_and_count_file(File.join(@test_dir, 'empty.txt'))
    expected_path = File.join(@test_dir, 'empty.txt')
    assert_equal({ lines: 0, words: 0, bytes: 0, file_path: expected_path }, result)
  end

  def test_single_line_no_newline
    result = read_and_count_file(File.join(@test_dir, 'single_line.txt'))
    expected_path = File.join(@test_dir, 'single_line.txt')
    assert_equal({ lines: 0, words: 4, bytes: 27, file_path: expected_path }, result)
  end

  def test_japanese_file
    result = read_and_count_file(File.join(@test_dir, 'japanese.txt'))
    expected_path = File.join(@test_dir, 'japanese.txt')
    assert_equal({ lines: 2, words: 2, bytes: 23, file_path: expected_path }, result)
  end

  def test_nonexistent_file
    _stdout, stderr = capture_io do
      result = read_and_count_file('nonexistent.txt')
      assert_nil result
    end

    assert_match(/wc: nonexistent.txt: No such file or directory/, stderr)
  end

  def test_directory
    _stdout, stderr = capture_io do
      result = read_and_count_file(@test_dir)
      assert_nil result
    end

    assert_match(/wc: #{Regexp.escape(@test_dir)}: Is a directory/, stderr)
  end
end
