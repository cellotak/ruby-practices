# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/grid_format'
require_relative '../lib/entry_list'

class GridFormatTest < Minitest::Test
  StubEntry = Struct.new(:name, :mode_string, :nlink, :owner, :group, :filesize, :mtime_string)

  def setup
    entries = ('a'..'e').map { |name| StubEntry.new("#{name}.txt") }
    @list = EntryList.new(entries)

    @format = GridFormat.new
  end

  def test_output
    output = @format.output(@list)

    rows = output.split("\n")

    # 3列固定なので、a, c, e が1行目に並ぶはず
    assert_match(/a\.txt\s+c\.txt\s+e\.txt/, rows[0])

    # 2行目には b, d が並ぶはず
    assert_match(/b\.txt\s+d\.txt/, rows[1])
  end
end
