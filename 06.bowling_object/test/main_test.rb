# frozen_string_literal: true

require 'minitest/autorun'

class MainTest < Minitest::Test

  def test_main
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    $stdout = StringIO.new
    load './libs/main.rb'
    out = $stdout.string
    assert_equal '164', out.lines[0].chomp
  end
end
