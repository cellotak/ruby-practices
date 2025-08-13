# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class MainFilesTest < Minitest::Test
  def setup
    @test_dir = File.join(__dir__, 'fixtures')
  end

  def test_multiple_files_with_total
    file1_path = File.join(@test_dir, 'file1.txt')
    file2_path = File.join(@test_dir, 'file2.txt')

    original_argv = ARGV.dup
    ARGV.replace([file1_path, file2_path])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 3, lines.size

    assert_equal " 2  2 12 #{file1_path}", lines[0]
    assert_equal " 3  8 35 #{file2_path}", lines[1]
    assert_equal ' 5 10 47 total', lines[2]
  end

  def test_single_file_no_total
    file1_path = File.join(@test_dir, 'file1.txt')

    original_argv = ARGV.dup
    ARGV.replace([file1_path])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 1, lines.size # totalがないことを確認
    assert_equal " 2  2 12 #{file1_path}", lines[0]
  end

  def test_multiple_files_with_options
    file1_path = File.join(@test_dir, 'file1.txt')
    file2_path = File.join(@test_dir, 'file2.txt')

    original_argv = ARGV.dup
    ARGV.replace(['-l', file1_path, file2_path])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 3, lines.size

    # -lオプションなので行数のみ表示
    assert_equal " 2 #{file1_path}", lines[0]
    assert_equal " 3 #{file2_path}", lines[1]
    assert_equal ' 5 total', lines[2]
  end
end
