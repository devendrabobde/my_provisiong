class RedisUpdate
  @queue = :cached_updation
  def self.perform
    RedisCache.update_validations_cached
  end
end
