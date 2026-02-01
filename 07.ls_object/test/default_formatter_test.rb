# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/default_formatter'
require_relative '../lib/entry_list'

class DefaultFormatterTest < Minitest::Test
  StubEntry = Struct.new(:name, :mode_string, :nlink, :owner, :group, :filesize, :mtime_string)

  def setup
    entries = ('a'..'e').map { |name| StubEntry.new("#{name}.txt") }
    @list = EntryList.new(entries)

    @formatter = DefaultFormatter.new
  end

  def test_format
    output = @formatter.format(@list)

    rows = output.split("\n")

    # 3列固定なので、a, c, e が1行目に並ぶはず
    assert_match(/a\.txt\s+c\.txt\s+e\.txt/, rows[0])

    # 2行目には b, d が並ぶはず
    assert_match(/b\.txt\s+d\.txt/, rows[1])
  end
end
