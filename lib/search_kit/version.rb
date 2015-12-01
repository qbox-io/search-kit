module SearchKit
  def self.gem_version
    Gem::Version.new(version_string)
  end

  def self.version_string
    VERSION::STRING
  end

  # A convenience measure for easy and quick-to-read version changes and lookup.
  #
  module VERSION
    MAJOR = 0
    MINOR = 0
    TINY  = 9
    PRE   = nil

    STRING = [ MAJOR, MINOR, TINY, PRE ].compact.join(".")
  end
end
