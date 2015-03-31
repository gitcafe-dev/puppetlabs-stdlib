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
      "kib" => "K",
      "gib" => "G",
      "tib" => "T",
      "pib" => "P",
      "eib" => "E",
    }
    begin
      _binary = output.split("\n").find{ |e| e =~ regex }.split(",").map(&:strip).last
      num, unit = _binary.split(" ")
      unit.gsub!(unit, FILE_MAPPING[unit.downcase.strip])
      "#{num.to_i}#{unit}"
    rescue
      raise Puppet::ParseError, 'partition_size(): Cannot parse the disk info.'
    end
  end
end
