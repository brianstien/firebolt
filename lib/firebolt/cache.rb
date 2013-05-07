require 'secure_random'

require 'firebolt/cache/sweeper'
require 'firebolt/cache/warmer'

module Firebolt
  module Cache

    def self.cache_key(type)
      "#{::Firebolt.config.namespace}.#{type}"
    end

    def self.entry_key_prefix(salt = nil)
      salt ||= self.salt
      "#{cache_key(:entry)}.#{salt}"
    end

    def self.keys_key
      cache_key(:keys)
    end

    def self.generate_salt
      ::SecureRandom.hex
    end

    def self.reset_salt!(new_salt)
      ::Firebolt.config.cache.write(self.salt_key, new_salt)
    end

    def self.salt
      ::Firebolt.config.cache.fetch(self.salt_key) do
        self.generate_salt
      end
    end

    def self.salt_key
      cache_key(:salt)
    end
  end
end
