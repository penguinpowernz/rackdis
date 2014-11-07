module Rackdis
  class Config
    
    def self.defaults
      {
        port:           7380,
        address:        "0.0.0.0",
        daemonize:      false,
        log:            STDOUT,
        log_level:      "info",
        db:             0,
        allow_unsafe:   false,
        force_enable:   [],
        allow_batching: false,
        redis:          "127.0.0.1:6379"
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
      process_log
      process_redis
    end

    def process_log
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

    def process_redis
      if @config[:redis].include? ":"
        parts = @config[:redis].split(":")
        port = parts.last
        host = parts.first
      else
        host = @config[:redis]
      end
      
      host = "127.0.0.1" if host.nil? or host.empty?
      port = 6379 if port.nil? or port.empty?
      
      @config[:redis_port] = port
      @config[:redis_host] = host
    end

  end
end