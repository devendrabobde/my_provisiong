#This module holds various regular expressions in constants
module RegularExpressionsHelper
  #This constant holds the regular expression for cutting search terms used in filters
  CUT_TERM  = /^.+?[\s-]/

  #This constant holds the regular expression for cutting emails used in filters
  CUT_EMAIL = /@.+$/
end