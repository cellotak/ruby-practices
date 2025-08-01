# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../wc'

class TestReadAndCountFile < Minitest::Test
  def setup
    @test_dir = File.dirname(__dir__)  # test_directory のパス
  end

  def test_returns_stats
    capture_io do
      result = read_and_count_file(file_path: File.join(@test_dir, 'file1.txt'))
      assert_equal({ lines: 2, words: 2, bytes: 12 }, result)
    end
  end

  def test_empty_file
    capture_io do
      result = read_and_count_file(file_path: File.join(@test_dir, 'empty.txt'))
      assert_equal({ lines: 0, words: 0, bytes: 0 }, result)
    end
  end

  def test_single_line_no_newline
    capture_io do
      result = read_and_count_file(file_path: File.join(@test_dir, 'single_line.txt'))
      assert_equal({ lines: 0, words: 4, bytes: 27 }, result)
    end
  end

  def test_japanese_file
    capture_io do
      result = read_and_count_file(file_path: File.join(@test_dir, 'japanese.txt'))
      assert_equal({ lines: 2, words: 2, bytes: 23 }, result)
    end
  end

  def test_nonexistent_file
    output = capture_io do
      result = read_and_count_file(file_path: 'nonexistent.txt')
      assert_nil result
    end

    assert_match(/wc: nonexistent.txt: No such file or directory/, output[0])
  end

  def test_directory
    output = capture_io do
      result = read_and_count_file(file_path: @test_dir)
      assert_nil result
    end

    assert_match(/wc: #{Regexp.escape(@test_dir)}: Is a directory/, output[0])
  end
end
