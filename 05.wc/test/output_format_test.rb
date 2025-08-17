# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class OutputFormatTest < Minitest::Test
  def test_no_options
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: 'test.txt' }
    options = {}
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal " 2  6 27 test.txt\n", output[0]
  end

  def test_with_l_option
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: 'test.txt' }
    options = { lines: true }
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal " 2 test.txt\n", output[0]
  end

  def test_with_w_option
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: 'test.txt' }
    options = { words: true }
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal " 6 test.txt\n", output[0]
  end

  def test_with_c_option
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: 'test.txt' }
    options = { bytes: true }
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal "27 test.txt\n", output[0]
  end

  def test_with_multiple_options
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: 'test.txt' }
    options = { lines: true, words: true }
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal " 2  6 test.txt\n", output[0]
  end

  def test_large_numbers_with_larger_width
    count_stats = { lines: 123, words: 456, bytes: 789, file_path: 'large.txt' }
    options = {}
    max_width = 3

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal "123 456 789 large.txt\n", output[0]
  end

  def test_without_file_path
    count_stats = { lines: 2, words: 6, bytes: 27, file_path: nil }
    options = {}
    max_width = 2

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal " 2  6 27\n", output[0]
  end

  def test_width_affects_all_values
    count_stats = { lines: 1, words: 2, bytes: 3, file_path: 'test.txt' }
    options = {}
    max_width = 5

    output = capture_io do
      output_format(count_stats, options, max_width)
    end

    assert_equal "    1     2     3 test.txt\n", output[0]
  end
end
