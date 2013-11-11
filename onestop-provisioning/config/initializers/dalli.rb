$memcached = Dalli::Client.new(Settings.memcache_server,{ :namespace => 'Onestop'})
Resque.enqueue(MemcachedUpdate)
