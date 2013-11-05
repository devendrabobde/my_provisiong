class Formats
  ADDRESS      = /^[\w\s]+$/.freeze
  BOOLEAN      = /^[01]$/.freeze
  EMAIL        = /^.+@.+\..+$/.freeze
  IDP_LEVEL    = /^[1-5]$/.freeze
  IP_ADDRESS   = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.freeze
  NPI          = /^\d{10}$/.freeze
  PASSWORD     = /^[A-Za-z0-9]{50,80}$/.freeze
  PERSON_NAME  = /^[a-zA-Z'-]+$/.freeze
  PHONE_NUMBER = /^\+?[\d.-]+$/.freeze
  SERVICE_NAME = /^[\w\s-\.]+$/.freeze
  SLUG         = /^[a-z0-9-]+$/.freeze
  STATE        = /^[A-Z]{2}$/.freeze
  USERNAME     = /^[a-zA-Z0-9_.-]+$/.freeze
  URL          = URI.regexp
end