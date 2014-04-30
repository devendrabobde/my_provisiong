CONSTANT = YAML.load(File.open("#{Rails.root}/config/constants.yml"))
VALIDATION_MESSAGE = YAML.load(File.open("#{Rails.root}/config/validation.yml"))
AppConfig = YAML.load(File.open("#{Rails.root}/config/application.yml"))
US_STATES = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL",
	"GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD",
	"MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND",
	"MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT",
	"VT", "VI", "VA", "WA", "WV", "WI", "WY"]
SERVER_CONFIGURATION = YAML.load(File.read("#{Rails.root}/config/server.yml"))[Rails.env].freeze
US_STATE_LIST = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'District Of Columbia', 'Florida', 
                'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana','Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts',
                'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
                'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
                'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
