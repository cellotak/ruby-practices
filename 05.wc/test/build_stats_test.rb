# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class BuildStatsTest < Minitest::Test
  def test_basic_content
    content = "hello world\nthis is a test\n"
    result = build_stats(content)
    assert_equal({ lines: 2, words: 6, bytes: 27, file_path: nil }, result)
  end

  def test_no_final_newline
    content = "hello world\nthis is a test"
    result = build_stats(content)
    assert_equal({ lines: 1, words: 6, bytes: 26, file_path: nil }, result)
  end

  def test_empty_string
    content = ''
    result = build_stats(content)
    assert_equal({ lines: 0, words: 0, bytes: 0, file_path: nil }, result)
  end

  def test_single_line_no_newline
    content = 'hello world'
    result = build_stats(content)
    assert_equal({ lines: 0, words: 2, bytes: 11, file_path: nil }, result)
  end

  def test_single_line_with_newline
    content = "hello world\n"
    result = build_stats(content)
    assert_equal({ lines: 1, words: 2, bytes: 12, file_path: nil }, result)
  end

  def test_multiple_spaces
    content = "hello    world\n  test  \n"
    result = build_stats(content)
    assert_equal({ lines: 2, words: 3, bytes: 24, file_path: nil }, result)
  end

  def test_empty_lines
    content = "hoge\n\nhoge\n"
    result = build_stats(content)
    assert_equal({ lines: 3, words: 2, bytes: 11, file_path: nil }, result)
  end

  def test_only_newlines
    content = "\n\n\n"
    result = build_stats(content)
    assert_equal({ lines: 3, words: 0, bytes: 3, file_path: nil }, result)
  end

  def test_multibyte_characters
    content = "こんにちは\n世界\n"
    result = build_stats(content)
    assert_equal({ lines: 2, words: 2, bytes: 23, file_path: nil }, result)
  end

  def test_with_file_path
    content = "hello world\ntest\n"
    result = build_stats(content, '/path/to/file.txt')
    assert_equal({ lines: 2, words: 3, bytes: 17, file_path: '/path/to/file.txt' }, result)
  end
end
