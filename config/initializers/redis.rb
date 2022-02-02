require 'connection_pool'

REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
default = REDIS_CONFIG[:default].symbolize_keys
config = default.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => config[:host], :port => config[:port]) }
Redis::Objects.redis.flushdb if Rails.env == "test"
