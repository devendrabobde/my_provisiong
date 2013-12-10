# Cache the different types of application validations as per batch upload models
class RedisUpdate
  @queue = :cached_updation
  def self.perform
    RedisCache.update_validations_cached
  end
end
