module Rackdis
  class Config

    DEFAULTS = {
      port: 7380,
      address: "0.0.0.0",
      daemonize: false
    }
    
    def initialize(opts)
      @config = DEFAULTS.clone
      process_options opts
    end

    def rack_options
      {
        Port: @config[:port],
        Host: @config[:address],
        daemonize: @config[:daemonize]
      }
    end
    
      process_options opts
    def [](key)
      @config[key]
    end
    
    private
    
    def process_options(opts)
      load_from_file opts[:config]
      
      # We want to merge the command line opts
      # overtop of the config file options but
      # only if they are set because when they
      # are not set they are nil which ends up
      # wiping out all of the config
      opts.each do |key, value|
        next if value.nil?
        @config[key] = value
      end
    end
    
    def load_from_file(file)
      return false if file.nil?
      raise ArgumentError, "Invalid config file: #{file}" unless File.exist? file
      @config.merge!(YAML.load_file(file))
    end

  end
end