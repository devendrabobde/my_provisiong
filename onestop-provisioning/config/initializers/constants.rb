CONSTANT = YAML.load(File.open("#{Rails.root}/config/constants.yml"))
VALIDATION_MESSAGE = YAML.load(File.open("#{Rails.root}/config/validation.yml"))
US_STATES = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", 
	"GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", 
	"MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", 
	"MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT",
	"VT", "VI", "VA", "WA", "WV", "WI", "WY"]
SERVER_CONFIGURATION = YAML.load(File.open("#{Rails.root}/config/server.yml"))
