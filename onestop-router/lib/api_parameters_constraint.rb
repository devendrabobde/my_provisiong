class ApiParametersConstraint
  PARAMETER_MAP = {
    :npi        => Formats::NPI,
    :first_name => Formats::PERSON_NAME,
    :last_name  => Formats::PERSON_NAME,
    :enabled    => Formats::BOOLEAN,
    :idp_level  => Formats::IDP_LEVEL,
    :ois_id     => Formats::SLUG,
    :token      => Formats::PASSWORD
  }.freeze

  def self.matches?(request)
    params         = request.params.symbolize_keys
    invalid_values = lambda { |key, value| PARAMETER_MAP.has_key?(key) && !PARAMETER_MAP[key].match(value) }

    if params.any?(&invalid_values)
      invalid_keys = params.find_all(&invalid_values).map(&:first)
      raise OneStopRequestError.new(code: 'invalid-request', message: "The following parameters are invalid: #{invalid_keys.join(', ')}")
    else
      true
    end
  end
end
