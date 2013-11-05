class OneStopRequestError < OneStopError
  category 'request'
  code     'unknown-error'
  message  'Unknown Request Error'
  status   :ok

  def self.error_type(options)
    error_details = Proc.new do
      category 'request'
      code     options[:code]
      message  options[:message]
      status   options[:status]
    end

    Class.new(self, &error_details)
  end
end
