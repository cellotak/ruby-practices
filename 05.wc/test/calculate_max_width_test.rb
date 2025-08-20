# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class CalculateMaxWidthTest < Minitest::Test
  def test_single_file
    stats_list = [
      { lines: 2, words: 6, bytes: 27, file_path: 'file1.txt' }
    ]
    total_stats = nil

    result = calculate_max_width(stats_list, total_stats)
    assert_equal 2, result
  end

  def test_multiple_files
    stats_list = [
      { lines: 20, words: 60, bytes: 500, file_path: 'file1.txt' },
      { lines: 30, words: 80, bytes: 501, file_path: 'file2.txt' }
    ]
    total_stats = { lines: 50, words: 140, bytes: 1001, file_path: 'total' }

    result = calculate_max_width(stats_list, total_stats)
    assert_equal 4, result
  end
end
