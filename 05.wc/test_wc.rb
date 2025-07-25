require 'minitest/autorun'
require_relative 'wc'

class TestWc < Minitest::Test
  def test_parse_options_with_l_option
    options, file_paths = parse_options(['-l'])
    assert_equal({ l: true }, options)
    assert_equal([], file_paths)
  end

  def test_parse_options_with_w_option
    options, file_paths = parse_options(['-w'])
    assert_equal({ w: true }, options)
    assert_equal([], file_paths)
  end

  def test_parse_options_with_c_option
    options, file_paths = parse_options(['-c'])
    assert_equal({ c: true }, options)
    assert_equal([], file_paths)
  end

  def test_parse_options_with_multiple_options
    options, file_paths = parse_options(['-l', '-w', '-c'])
    assert_equal({ l: true, w: true, c: true }, options)
    assert_equal([], file_paths)
  end

  def test_parse_options_with_file_paths
    options, file_paths = parse_options(['file1.txt', 'file2.txt'])
    assert_equal({}, options)
    assert_equal(['file1.txt', 'file2.txt'], file_paths)
  end

  def test_parse_options_with_options_and_file_paths
    options, file_paths = parse_options(['-l', '-w', 'file1.txt', 'file2.txt'])
    assert_equal({ l: true, w: true }, options)
    assert_equal(['file1.txt', 'file2.txt'], file_paths)
  end

  def test_count_content_basic
    content = "hello world\nthis is a test\n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 6, bytes: 27 }, result)
  end

  def test_count_content_no_final_newline
    content = "hello world\nthis is a test"
    result = count_content(content)
    assert_equal({ lines: 1, words: 6, bytes: 26 }, result)
  end

  def test_count_content_empty_string
    content = ""
    result = count_content(content)
    assert_equal({ lines: 0, words: 0, bytes: 0 }, result)
  end

  def test_count_content_single_line_no_newline
    content = "hello world"
    result = count_content(content)
    assert_equal({ lines: 0, words: 2, bytes: 11 }, result)
  end

  def test_count_content_single_line_with_newline
    content = "hello world\n"
    result = count_content(content)
    assert_equal({ lines: 1, words: 2, bytes: 12 }, result)
  end

  def test_count_content_multiple_spaces
    content = "hello    world\n  test  \n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 3, bytes: 24 }, result)
  end

  def test_count_content_empty_lines
    content = "hoge\n\nhoge\n"
    result = count_content(content)
    assert_equal({ lines: 3, words: 2, bytes: 11 }, result)
  end

  def test_count_content_only_newlines
    content = "\n\n\n"
    result = count_content(content)
    assert_equal({ lines: 3, words: 0, bytes: 3 }, result)
  end

  def test_count_content_multibyte_characters
    content = "こんにちは\n世界\n"
    result = count_content(content)
    assert_equal({ lines: 2, words: 2, bytes: 23 }, result)
  end

  def test_output_format_no_options
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = {}
    file_path = "test.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 27 test.txt\n", output[0]
  end

  def test_output_format_with_l_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { l: true }
    file_path = "test.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2 test.txt\n", output[0]
  end

  def test_output_format_with_w_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { w: true }
    file_path = "test.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 6 test.txt\n", output[0]
  end

  def test_output_format_with_c_option
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { c: true }
    file_path = "test.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal "27 test.txt\n", output[0]
  end

  def test_output_format_with_multiple_options
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = { l: true, w: true }
    file_path = "test.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 test.txt\n", output[0]
  end

  def test_output_format_large_numbers
    count_stats = { lines: 123, words: 456, bytes: 789 }
    options = {}
    file_path = "large.txt"

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal "123 456 789 large.txt\n", output[0]
  end

  def test_output_format_without_file_path
    count_stats = { lines: 2, words: 6, bytes: 27 }
    options = {}
    file_path = nil

    output = capture_io do
      output_format(count_stats, options, file_path)
    end

    assert_equal " 2  6 27\n", output[0]
  end

  def test_read_and_count_file_returns_stats
    capture_io do
      result = read_and_count_file('test_directory/file1.txt')
      assert_equal({ lines: 2, words: 2, bytes: 12 }, result)
    end
  end

  def test_read_and_count_file_empty_file
    capture_io do
      result = read_and_count_file('test_directory/empty.txt')
      assert_equal({ lines: 0, words: 0, bytes: 0 }, result)
    end
  end

  def test_read_and_count_file_single_line_no_newline
    capture_io do
      result = read_and_count_file('test_directory/single_line.txt')
      assert_equal({ lines: 0, words: 4, bytes: 27 }, result)
    end
  end

  def test_read_and_count_file_japanese
    capture_io do
      result = read_and_count_file('test_directory/japanese.txt')
      assert_equal({ lines: 2, words: 2, bytes: 23 }, result)
    end
  end

  def test_read_and_count_file_nonexistent_file
    output = capture_io do
      result = read_and_count_file('nonexistent.txt')
      assert_nil result
    end

    assert_match(/wc: nonexistent.txt: No such file or directory/, output[0])
  end

  def test_read_and_count_file_directory
    output = capture_io do
      result = read_and_count_file('test_directory')
      assert_nil result
    end

    assert_match(/wc: test_directory: Is a directory/, output[0])
  end

  def test_multiple_files_with_total
    original_argv = ARGV.dup
    ARGV.replace(['test_directory/file1.txt', 'test_directory/file2.txt'])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 3, lines.size

    assert_equal " 2  2 12 test_directory/file1.txt", lines[0]
    assert_equal " 3  8 35 test_directory/file2.txt", lines[1]
    assert_equal " 5 10 47 total", lines[2]
  end

  def test_single_file_no_total
    original_argv = ARGV.dup
    ARGV.replace(['test_directory/file1.txt'])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 1, lines.size  # totalがないことを確認
    assert_equal " 2  2 12 test_directory/file1.txt", lines[0]
  end

  def test_multiple_files_with_options
    original_argv = ARGV.dup
    ARGV.replace(['-l', 'test_directory/file1.txt', 'test_directory/file2.txt'])

    output = capture_io do
      main
    ensure
      ARGV.replace(original_argv)
    end

    lines = output[0].split("\n")
    assert_equal 3, lines.size

    assert_equal " 2 test_directory/file1.txt", lines[0]
    assert_equal " 3 test_directory/file2.txt", lines[1]
    assert_equal " 5 total", lines[2]
  end

  def test_count_ls_output_via_pipe
    ls_output = <<~OUTPUT
      total 16
      drwxr-xr-x 2 user user 4096 Jul  9 01:08 .
      drwxr-xr-x 3 user user 4096 Jul 10 00:50 ..
      -rw-r--r-- 1 user user    5 Jul  9 01:08 file1.txt
      -rw-r--r-- 1 user user    9 Jul  9 01:07 file2.txt
    OUTPUT

    # STDIN.tty? が false を返すようにモック（パイプ接続をシミュレート）
    STDIN.stub :tty?, false do
      STDIN.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace([])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        assert_equal " 5 38 198\n", output[0]
      end
    end
  end

  def test_count_ls_output_with_l_option_via_pipe
    ls_output = <<~OUTPUT
      total 16
      drwxr-xr-x 2 user user 4096 Jul  9 01:08 .
      drwxr-xr-x 3 user user 4096 Jul 10 00:50 ..
      -rw-r--r-- 1 user user    5 Jul  9 01:08 file1.txt
      -rw-r--r-- 1 user user    9 Jul  9 01:07 file2.txt
    OUTPUT

    STDIN.stub :tty?, false do
      STDIN.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace(['-l'])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        lines = ls_output.count("\n")
        assert_equal " 5\n", output[0]
      end
    end
  end

  def test_count_ls_output_with_w_option_via_pipe
    ls_output = <<~OUTPUT
      total 8
      -rw-r--r-- 1 user user 12 Jul  9 01:08 test.txt
      lrwxrwxrwx 1 user user  8 Jul  9 01:08 link.txt -> test.txt
    OUTPUT

    STDIN.stub :tty?, false do
      STDIN.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace(['-w'])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        words = ls_output.split.size
        assert_equal "22\n", output[0]
      end
    end
  end

  def test_count_ls_output_with_c_option_via_pipe
    ls_output = <<~OUTPUT
      total 4
      -rw-r--r-- 1 user user 100 Jul  9 01:08 example.txt
    OUTPUT

    STDIN.stub :tty?, false do
      STDIN.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace(['-c'])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        assert_equal "60\n", output[0]
      end
    end
  end

  def test_count_empty_ls_output_via_pipe
    ls_output = ""

    STDIN.stub :tty?, false do
      STDIN.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace([])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        assert_equal " 0  0  0\n", output[0]
      end
    end
  end
end