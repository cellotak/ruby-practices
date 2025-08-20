# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class CalculateMaxWidthTest < Minitest::Test
  def test_single_file
    file_info_list = [
      { stats: { lines: 2, words: 6, bytes: 27 }, path: 'file1.txt' }
    ]
    total_stats = { lines: 2, words: 6, bytes: 27 }

    result = calculate_max_width(file_info_list, total_stats)
    assert_equal 2, result
  end

  def test_multiple_files
    file_info_list = [
      { stats: { lines: 20, words: 60, bytes: 500 }, path: 'file1.txt' },
      { stats: { lines: 30, words: 80, bytes: 501 }, path: 'file2.txt' }
    ]
    total_stats = { lines: 50, words: 140, bytes: 1001 }

    result = calculate_max_width(file_info_list, total_stats)
    assert_equal 4, result
  end
end
