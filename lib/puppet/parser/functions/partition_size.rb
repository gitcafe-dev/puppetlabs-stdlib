module Puppet::Parser::Functions
  newfunction(:partition_size, type: :rvalue, doc: <<-EOS
Returns the partition size of gdisk -l device_path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "partition_size(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(String)
      raise(Puppet::ParseError, 'partition_size(): Requires string to work with')
    end

    output = `gdisk -l #{value}`
    regex = /^Disk #{value}/
    FILE_MAPPING = {
      "kib" => 1024 ** -1,
      "mib" => 1,
      "gib" => 1024,
      "tib" => 1024 ** 2,
      "pib" => 1024 ** 3,
      "eib" => 1024 ** 4,
    }
    begin
      _binary = output.split("\n").find{ |e| e =~ regex }.split(",").map(&:strip).last
      num, unit = _binary.split(" ")

      factor = FILE_MAPPING[unit.downcase.strip]
      num = (num.to_i * factor - 4).to_s
      "#{num}M"
    rescue
      raise Puppet::ParseError, 'partition_size(): Cannot parse the disk info.'
    end
  end
end
