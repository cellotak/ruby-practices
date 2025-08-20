# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class CollectStdinStatsTest < Minitest::Test
  def test_collect_stdin_stats_with_content
    input_content = <<~CONTENT
      hello world
      this is a test
      end of file
    CONTENT

    $stdin.stub :read, input_content do
      stats_list, total_stats = collect_stdin_stats

      assert_equal 1, stats_list.size
      assert_equal({ lines: 3, words: 9, bytes: 39, file_path: nil }, stats_list[0])
      assert_nil total_stats
    end
  end

  def test_collect_stdin_stats_with_empty_content
    input_content = ''

    $stdin.stub :read, input_content do
      stats_list, total_stats = collect_stdin_stats

      assert_equal 1, stats_list.size
      assert_equal({ lines: 0, words: 0, bytes: 0, file_path: nil }, stats_list[0])
      assert_nil total_stats
    end
  end

  def test_collect_stdin_stats_with_single_line_no_newline
    input_content = 'hello world'

    $stdin.stub :read, input_content do
      stats_list, total_stats = collect_stdin_stats

      assert_equal 1, stats_list.size
      assert_equal({ lines: 0, words: 2, bytes: 11, file_path: nil }, stats_list[0])
      assert_nil total_stats
    end
  end

  def test_collect_stdin_stats_with_only_whitespace
    input_content = "   \n  \t  \n   "

    $stdin.stub :read, input_content do
      stats_list, total_stats = collect_stdin_stats

      assert_equal 1, stats_list.size
      assert_equal({ lines: 2, words: 0, bytes: 13, file_path: nil }, stats_list[0])
      assert_nil total_stats
    end
  end
end
