module Puppet::Parser::Functions
  newfunction(:realpath, type: :rvalue, doc: <<-EOS
Returns the real(absolute) path of the given path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "realpath(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(String)
      raise(Puppet::ParseError, 'realpath(): Requires string to work with')
    end

    File.realpath(value)
  end
end
