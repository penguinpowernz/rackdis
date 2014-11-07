module Rackdis
  class Config
    
    def self.defaults
      {
        port:         7380,
        address:      "0.0.0.0",
        daemonize:    false,
        log:          STDOUT,
        log_level:    "info",
        db:           0,
        allow_unsafe: false,
        force_enable: []
      }
    end
    
    def initialize(opts)
      @config = Config.defaults
      process_options opts
      post_process
    end

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

    def post_process
      @config[:log] = case @config[:log]
      when nil, "", " ", "no", "none"
        "/dev/null"
      when "stdout", "-", "STDOUT"
        STDOUT
      when "stderr", "STDERR"
        STDERR
      else
        @config[:log]
      end
      
      @config[:log] = "/dev/null" if @config[:log_level] == "shutup"
    end

  end
end