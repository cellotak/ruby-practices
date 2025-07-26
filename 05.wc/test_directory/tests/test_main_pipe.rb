# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../wc'

class TestMainPipe < Minitest::Test
  def test_count_ls_output_via_pipe
    ls_output = <<~OUTPUT
      total 16
      drwxr-xr-x 2 user user 4096 Jul  9 01:08 .
      drwxr-xr-x 3 user user 4096 Jul 10 00:50 ..
      -rw-r--r-- 1 user user    5 Jul  9 01:08 file1.txt
      -rw-r--r-- 1 user user    9 Jul  9 01:07 file2.txt
    OUTPUT

    $stdin.stub :tty?, false do
      $stdin.stub :read, ls_output do
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

  def test_with_l_option_via_pipe
    ls_output = <<~OUTPUT
      total 16
      drwxr-xr-x 2 user user 4096 Jul  9 01:08 .
      drwxr-xr-x 3 user user 4096 Jul 10 00:50 ..
      -rw-r--r-- 1 user user    5 Jul  9 01:08 file1.txt
      -rw-r--r-- 1 user user    9 Jul  9 01:07 file2.txt
    OUTPUT

    $stdin.stub :tty?, false do
      $stdin.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace(['-l'])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        assert_equal " 5\n", output[0]
      end
    end
  end

  def test_with_w_option_via_pipe
    ls_output = <<~OUTPUT
      total 8
      -rw-r--r-- 1 user user 12 Jul  9 01:08 test.txt
      lrwxrwxrwx 1 user user  8 Jul  9 01:08 link.txt -> test.txt
    OUTPUT

    $stdin.stub :tty?, false do
      $stdin.stub :read, ls_output do
        original_argv = ARGV.dup
        ARGV.replace(['-w'])

        output = capture_io do
          main
        ensure
          ARGV.replace(original_argv)
        end

        assert_equal "22\n", output[0]
      end
    end
  end

  def test_with_c_option_via_pipe
    ls_output = <<~OUTPUT
      total 4
      -rw-r--r-- 1 user user 100 Jul  9 01:08 example.txt
    OUTPUT

    $stdin.stub :tty?, false do
      $stdin.stub :read, ls_output do
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

  def test_empty_input_via_pipe
    ls_output = ''

    $stdin.stub :tty?, false do
      $stdin.stub :read, ls_output do
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
