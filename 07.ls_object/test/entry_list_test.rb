# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/entry_list'

class EntryListTest < Minitest::Test
  StubEntry = Struct.new(:name, :filesize, :nlink, :blocks, :owner, :group, :mode_string, :mtime_string)

  def setup
    # 各属性の最大幅にならないスタブ
    not_max_width_entryentry1 = StubEntry.new('a.txt', '1', '1', 1, 'usr', 'grp', '-rw-r--r--', 'Jan 1')

    # 各属性が最大幅になるスタブ
    max_width_entry = StubEntry.new('long_name.txt', '100', '10', 8, 'long_user', 'long_group', 'drwxr-xr-x', 'Jan 12 12:00')

    @list = EntryList.new([not_max_width_entryentry1, max_width_entry])
  end

  def test_total_blocks
    assert_equal 9, @list.total_blocks
  end

  def test_max_widths
    widths = @list.max_widths

    assert_equal 13, widths[:name]
    assert_equal 3,  widths[:filesize]
    assert_equal 9,  widths[:owner]
    assert_equal 10, widths[:group]
    assert_equal 2,  widths[:nlink]
    assert_equal 10, widths[:mode_string]
    assert_equal 12, widths[:mtime_string]
  end
end
