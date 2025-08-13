# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class CountContentTest < Minitest::Test
  def test_basic_content
    content = "hello world\nthis is a test\n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 6, bytes: 27 }, result)
  end

  def test_no_final_newline
    content = "hello world\nthis is a test"
    result = count_content(content)
    assert_equal({ lines: 1, words: 6, bytes: 26 }, result)
  end

  def test_empty_string
    content = ''
    result = count_content(content)
    assert_equal({ lines: 0, words: 0, bytes: 0 }, result)
  end

  def test_single_line_no_newline
    content = 'hello world'
    result = count_content(content)
    assert_equal({ lines: 0, words: 2, bytes: 11 }, result)
  end

  def test_single_line_with_newline
    content = "hello world\n"
    result = count_content(content)
    assert_equal({ lines: 1, words: 2, bytes: 12 }, result)
  end

  def test_multiple_spaces
    content = "hello    world\n  test  \n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 3, bytes: 24 }, result)
  end

  def test_empty_lines
    content = "hoge\n\nhoge\n"
    result = count_content(content)
    assert_equal({ lines: 3, words: 2, bytes: 11 }, result)
  end

  def test_only_newlines
    content = "\n\n\n"
    result = count_content(content)
    assert_equal({ lines: 3, words: 0, bytes: 3 }, result)
  end

  def test_multibyte_characters
    content = "こんにちは\n世界\n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 2, bytes: 23 }, result)
  end
end
