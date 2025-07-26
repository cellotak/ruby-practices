# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../wc'

class TestCollectFileStats < Minitest::Test
  def setup
    @test_dir = File.dirname(__dir__)
  end

  def test_multiple_files
    file1_path = File.join(@test_dir, 'file1.txt')
    file2_path = File.join(@test_dir, 'file2.txt')

    file_stats_list, total_stats = collect_file_stats([file1_path, file2_path])

    assert_equal 2, file_stats_list.size
    assert_equal({ lines: 2, words: 2, bytes: 12 }, file_stats_list[0][:stats])
    assert_equal file1_path, file_stats_list[0][:path]
    assert_equal({ lines: 3, words: 8, bytes: 35 }, file_stats_list[1][:stats])
    assert_equal file2_path, file_stats_list[1][:path]
    assert_equal({ lines: 5, words: 10, bytes: 47 }, total_stats)
  end

  def test_single_file
    file1_path = File.join(@test_dir, 'file1.txt')

    file_stats_list, total_stats = collect_file_stats([file1_path])

    assert_equal 1, file_stats_list.size
    assert_equal({ lines: 2, words: 2, bytes: 12 }, file_stats_list[0][:stats])
    assert_equal file1_path, file_stats_list[0][:path]
    assert_equal({ lines: 2, words: 2, bytes: 12 }, total_stats)
  end

  def test_with_nonexistent_file
    file1_path = File.join(@test_dir, 'file1.txt')

    capture_io do
      file_stats_list, total_stats = collect_file_stats([file1_path, 'nonexistent.txt'])

      assert_equal 1, file_stats_list.size
      assert_equal({ lines: 2, words: 2, bytes: 12 }, file_stats_list[0][:stats])
      assert_equal({ lines: 2, words: 2, bytes: 12 }, total_stats)
    end
  end
end
