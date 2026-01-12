# frozen_string_literal: true

require 'etc'

class Entry
  attr_reader :name, :stat

  FILE_TYPES = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze

  def initialize(dir_path, name)
    @dir_path = dir_path
    @name = name
    @stat = File.stat(path)
  end

  def path
    File.join(@dir_path, @name)
  end

  def blocks
    stat.blocks
  end

  def nlink
    stat.nlink.to_s
  end

  def filesize
    stat.size.to_s
  end

  def owner
    Etc.getpwuid(stat.uid).name
  end

  def group
    Etc.getgrgid(stat.gid).name
  end

  def mtime_string
    stat.mtime.strftime('%b %e %H:%M')
  end

  def mode_string
    convert_stat_mode_to_str(stat.mode)
  end

  private

  def convert_stat_mode_to_str(stat_mode)
    file_type_code = format('%06o', stat_mode).slice(0..1)
    file_type_char = FILE_TYPES[file_type_code] || '-'

    permission_code = format('%06o', stat_mode).slice(3..5)
    permission_str = convert_permission_code_to_str(permission_code)

    file_type_char + permission_str
  end

  def convert_permission_code_to_str(permission_code)
    permission_code_nums = permission_code.chars.map(&:to_i)
    permission_octets = permission_code_nums.map do |num|
      permission_octet_chars = []

      permission_octet_chars << (num / 4 == 1 ? 'r' : '-')
      permission_octet_chars << ((num / 2).odd? ? 'w' : '-')
      permission_octet_chars << (num.odd? ? 'x' : '-')

      permission_octet_chars.join
    end
    permission_octets.join
  end
end
