DATABASE_NAME = ENV['DATABASE_NAME'] || 'xe'
DATABASE_HOST = ENV['DATABASE_HOST']
DATABASE_PORT = ENV['DATABASE_PORT']
DATABASE_USER = ENV['DATABASE_USER'] || 'test'
DATABASE_PASSWORD = ENV['DATABASE_PASSWORD'] || 'test'
DATABASE_SYS_PASSWORD = ENV['DATABASE_SYS_PASSWORD'] || 'manager'

CONNECTION_PARAMS = {
  :adapter => "oracle_enhanced",
  :database => DATABASE_NAME,
  :host => DATABASE_HOST,
  :port => DATABASE_PORT,
  :username => DATABASE_USER,
  :password => DATABASE_PASSWORD
}

SYS_CONNECTION_PARAMS = {
  :adapter => "oracle_enhanced",
  :database => DATABASE_NAME,
  :host => DATABASE_HOST,
  :port => DATABASE_PORT,
  :username => "sys",
  :password => DATABASE_SYS_PASSWORD,
  :privilege => "SYSDBA"
}

SYSTEM_CONNECTION_PARAMS = {
  :adapter => "oracle_enhanced",
  :database => DATABASE_NAME,
  :host => DATABASE_HOST,
  :port => DATABASE_PORT,
  :username => "system",
  :password => DATABASE_SYS_PASSWORD
}

DATABASE_NON_DEFAULT_TABLESPACE = ENV['DATABASE_NON_DEFAULT_TABLESPACE'] || "SYSTEM"

# Set default $KCODE to UTF8
if RUBY_VERSION < "1.9"
  $KCODE = "UTF8"
end
