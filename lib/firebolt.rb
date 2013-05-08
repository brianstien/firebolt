require 'json'
require 'secure_random'

require 'firebolt/cache'
require 'firebolt/cache_worker'
require 'firebolt/config'
require 'firebolt/file_warmer'
require 'firebolt/warmer'

require "firebolt/version"

module Firebolt
  # Using a mutex to control access while creating a ::Firebolt::Config
  @firebolt_mutex = ::Mutex.new

  def self.config
    return @config unless @config.nil?

    @firebolt_mutex.synchronize do
      @config = ::Firebolt::Config.new if @config.nil?
    end

    return @config
  end

  def self.configure
    ::Thread.exclusive do
      yield(config)
    end
  end

  def self.initialize!
    # Setup SuckerPunch
    ::SuckerPunch.config do
      queue :name => :firebolt_queue, :worker => ::Firebolt::CacheWorker, :workers => 1
    end

    # Setup Rufus
    frequency = ::Rufus.to_time_string(config.frequency)
    ::Rufus::Scheduler.start_new.every(frequency) do
      ::SuckerPunch::Queue[:firebolt_queue].async.perform(config.warmer)
    end

    # Initial warming
    warmer = ::Firebolt.config.cache_file_enabled? ? ::Firebolt::FileWarmer : config.warmer
    ::SuckerPunch::Queue[:firebolt_queue].async.perform(warmer)
  end
end
