# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'open3'

class LsCommandTest < Minitest::Test
  SANDBOX_DIR = 'test/sandbox'

  def setup
    FileUtils.mkdir_p(SANDBOX_DIR)

    FileUtils.touch("#{SANDBOX_DIR}/file_a.txt")
    FileUtils.touch("#{SANDBOX_DIR}/file_b.txt")

    FileUtils.touch("#{SANDBOX_DIR}/.hidden")

    FileUtils.mkdir("#{SANDBOX_DIR}/subdir")
    FileUtils.touch("#{SANDBOX_DIR}/subdir/subfile.txt")
  end

  def teardown
    FileUtils.rm_rf(SANDBOX_DIR)
  end

  def run_ls(args = '')
    `ruby bin/ls.rb #{args}`
  end

  def run_ls_stderr(args = '')
    _out, err, _status = Open3.capture3("ruby bin/ls.rb #{args}")
    err
  end

  def test_basic_listing
    output = run_ls(SANDBOX_DIR)
    assert_match(/file_a\.txt/, output)
    assert_match(/file_b\.txt/, output)
  end

  def test_option_all
    output_default = run_ls(SANDBOX_DIR)
    refute_match(/\.hidden/, output_default)

    output_all = run_ls("-a #{SANDBOX_DIR}")
    assert_match(/\.hidden/, output_all)
  end

  def test_option_reverse
    output_default = run_ls(SANDBOX_DIR)
    assert output_default.index('file_a.txt') < output_default.index('file_b.txt'), 'Expected alphabetical order'

    output_reverse = run_ls("-r #{SANDBOX_DIR}")
    assert output_reverse.index('file_b.txt') < output_reverse.index('file_a.txt'), 'Expected reverse order'
  end

  def test_multiple_files
    output = run_ls("#{SANDBOX_DIR}/file_a.txt #{SANDBOX_DIR}/file_b.txt")
    assert_match(/file_a\.txt/, output)
    assert_match(/file_b\.txt/, output)
    refute_match(/subdir/, output)
  end

  def test_mixed_arguments
    output = run_ls("#{SANDBOX_DIR}/subdir #{SANDBOX_DIR}/file_a.txt")

    file_index = output.index('file_a.txt')
    dir_content_index = output.index('subfile.txt')

    assert file_index < dir_content_index, 'Files should be listed before directories'
  end

  def test_non_existent_file
    err = run_ls_stderr('nothing_here.txt')
    assert_match(/ls: cannot access 'nothing_here.txt': No such file or directory/, err)
  end

  def test_long_format_alignment
    File.write("#{SANDBOX_DIR}/bigfile", 'a' * 1000)

    output = run_ls("-l #{SANDBOX_DIR}/file_a.txt #{SANDBOX_DIR}/bigfile")

    assert_match(/file_a\.txt/, output)
    assert_match(/bigfile/, output)

    refute_match(/total/, output)
  end

  def test_long_format_directory
    output = run_ls("-l #{SANDBOX_DIR}")

    assert_match(/total/, output)
    assert_match(/file_a\.txt/, output)
  end

  def test_option_reverse_arguments
    output_default = run_ls("#{SANDBOX_DIR}/file_a.txt #{SANDBOX_DIR}/file_b.txt")
    assert output_default.index('file_a.txt') < output_default.index('file_b.txt')

    output_reverse = run_ls("-r #{SANDBOX_DIR}/file_a.txt #{SANDBOX_DIR}/file_b.txt")
    assert output_reverse.index('file_b.txt') < output_reverse.index('file_a.txt'), 'Arguments should be reversed'
  end
end
