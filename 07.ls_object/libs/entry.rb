# frozen_string_literal: true

class Entry
  attr_reader :basename, :dirname, :stat

  FILE_TYPE_LIST = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze

  def initialize(basename, dirname)
    @basename = basename
    @dirname = dirname
    @stat = File::Stat.new(path)
  end

  def path
    File.join(dirname, basename)
  end

  def stat_mode
    file_type_code = format('%06o', stat.mode).slice(0..1)
    file_type_char = FILE_TYPE_LIST[file_type_code]
  
    permission_code = format('%06o', stat.mode).slice(3..5)
    permission_str = convert_permission_code_to_str(permission_code)
  
    file_type_char + permission_str
  end

  def nlink
    stat.nlink.to_s
  end

  def username
    Etc.getpwuid(stat.uid).name
  end

  def groupname
    Etc.getgrgid(stat.gid).name
  end

  def size
    stat.size.to_s
  end

  def ctime
    stat.ctime.strftime('%b %e %H:%M')
  end
  
  def blocks
    stat.blocks
  end

  def details
    { 
      filename: basename,
      stat_mode: stat_mode,
      username: username,
      groupname: groupname,
      size: size,
      ctime: ctime
    }
  end

  private

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
