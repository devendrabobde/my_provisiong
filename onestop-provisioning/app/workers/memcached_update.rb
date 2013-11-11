class MemcachedUpdate
  @queue = :memcached_updation
  def self.perform
    Memcached.update_validations_memcached
  end
end