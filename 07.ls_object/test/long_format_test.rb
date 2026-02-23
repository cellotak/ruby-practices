# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/long_format'
require_relative '../lib/entry_list'

class LongFormatTest < Minitest::Test
  StubEntry = Struct.new(:name, :filesize, :nlink, :blocks, :owner, :group, :mode_string, :mtime_string)

  def setup
    # 各属性が最大幅ではないentry (paddingされる)
    not_max_width_entry = StubEntry.new('a.txt', '100', '1', 2, 'usr', 'grp', '-rw-r--r--', 'Jan  1 00:00')

    # 各属性が最大幅になるentry（この文字数に合わせて最大幅が決まる）
    max_width_entry = StubEntry.new('long_name.txt', '2000', '2', 2, 'root', 'wheel', 'drwxr-xr-x', 'Dec 31 23:59')

    @list = EntryList.new([not_max_width_entry, max_width_entry])
    @format = LongFormat.new
  end

  def test_output
    output = @format.output(@list)

    assert_match(/^total 2/, output)
    assert_match(/-rw-r--r--\s+1\s+usr\s+grp\s+100\s+Jan\s+1\s00:00\s+a.txt/, output)
    assert_match(/drwxr-xr-x\s+2\s+root\s+wheel\s+2000\s+Dec 31 23:59\s+long_name.txt/, output)
  end
end
