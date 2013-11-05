class Formats
  # ADDRESS      = /^[\w\s]+$/.freeze
  ADDRESS      = /^[^\-]*/.freeze
  EMAIL        = /^.+@.+\..+$/.freeze
  NPI          = /^\d{10}$/.freeze
  PERSON_NAME  = /^[a-zA-Z'-]+$/.freeze
  PHONE_NUMBER = /^\+?[\d.-]+$/.freeze
  SERVICE_NAME = /^[\w\s-\.]+$/.freeze
  STATE        = /^[A-Z]{2}$/.freeze
  USERNAME     = /^[a-zA-Z0-9_.-]+$/.freeze
  DEA_NUMBER   = /^[a-zA-Z]{2}+\d{7}$/.freeze
  DATE         = /^(0[1-9]|1[012])[\/](0[1-9]|[12][0-9]|3[01])[\/][0-9]{4}$/.freeze
  # ZIP          = /^\d{5}(?:[-\s]\d{4})?$/.freeze
  ZIP          = /^\d{5}((-|\s)?\d{4})?$/.freeze
  TIME         = /[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}$/.freeze
end
