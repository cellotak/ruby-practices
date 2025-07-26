# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../wc'

class TestOutputFormat < Minitest::Test
  def test_no_options
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = {}
    file_path = 'test.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 27 test.txt\n", output[0]
  end

  def test_with_l_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { l: true }
    file_path = 'test.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2 test.txt\n", output[0]
  end

  def test_with_w_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { w: true }
    file_path = 'test.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 6 test.txt\n", output[0]
  end

  def test_with_c_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { c: true }
    file_path = 'test.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal "27 test.txt\n", output[0]
  end

  def test_with_multiple_options
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { l: true, w: true }
    file_path = 'test.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 test.txt\n", output[0]
  end

  def test_large_numbers
    count_stats = { lines: 123, words: 456, bytes: 789 }
    options = {}
    file_path = 'large.txt'

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal "123 456 789 large.txt\n", output[0]
  end

  def test_without_file_path
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = {}
    file_path = nil

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 27\n", output[0]
  end
end
