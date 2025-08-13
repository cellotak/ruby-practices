# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class CollectFileStatsTest < Minitest::Test
  def setup
    @test_dir = File.join(__dir__, 'fixtures')
  end

  def test_single_file
    file_info_list, total_stats = collect_file_stats([File.join(@test_dir, 'file1.txt')])

    assert_equal 1, file_info_list.size
    assert_equal({ lines: 2, words: 2, bytes: 12 }, file_info_list[0][:stats])
    assert_equal File.join(@test_dir, 'file1.txt'), file_info_list[0][:path]
    assert_equal({ lines: 2, words: 2, bytes: 12 }, total_stats)
  end

  def test_multiple_files
    file_info_list, total_stats = collect_file_stats([File.join(@test_dir, 'file1.txt'), File.join(@test_dir, 'file2.txt')])

    assert_equal 2, file_info_list.size
    assert_equal({ lines: 2, words: 2, bytes: 12 }, file_info_list[0][:stats])
    assert_equal File.join(@test_dir, 'file1.txt'), file_info_list[0][:path]
    assert_equal({ lines: 3, words: 8, bytes: 35 }, file_info_list[1][:stats])
    assert_equal File.join(@test_dir, 'file2.txt'), file_info_list[1][:path]
    assert_equal({ lines: 5, words: 10, bytes: 47 }, total_stats)
  end
end
