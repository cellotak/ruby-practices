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

   def test_parse_ls_output
    ls_output = <<~OUTPUT
      total 16
      drwxr-xr-x 2 cellotak cellotak 4096 Jul  9 01:08 .
      drwxr-xr-x 3 cellotak cellotak 4096 Jul 10 00:50 ..
      -rw-r--r-- 1 cellotak cellotak    5 Jul  9 01:08 hoge1.txt
      -rw-r--r-- 1 cellotak cellotak    9 Jul  9 01:07 hoge2.txt
    OUTPUT

    result = parse_ls_output(ls_output)
    assert_equal(['hoge1.txt', 'hoge2.txt'], result)
  end

  def test_parse_ls_output_with_symlink
    ls_output = <<~OUTPUT
      total 8
      -rw-r--r-- 1 user user 5 Jul  9 01:08 file.txt
      lrwxrwxrwx 1 user user 8 Jul  9 01:08 link.txt -> file.txt
    OUTPUT

    result = parse_ls_output(ls_output)
    assert_equal(['file.txt', 'link.txt'], result)
  end
end
