class OneStopError < StandardError
  def self.category(category=nil)
    return @category unless category.present?
    @category = category
  end

  def self.code(code=nil)
    return @code unless code.present?

    @code = code
  end

  def self.message(message=nil)
    return @message unless message.present?
    @message = message
  end

  def self.status(status=nil)
    return @status unless status.present?
    @status = status
  end

  category 'system'
  code     'unknown-error'
  message  'Unidentified OneStop Error'
  status   :internal_server_error

  attr_writer :category, :code, :message, :status

  def initialize(options={})
    @code     = options[:code]
    @message  = options[:message]
    @category = options[:category]
    @status   = options[:status]
  end

  def category
    @category || self.class.category
  end

  def code
    @code || self.class.code
  end

  def message
    @message || self.class.message
  end

  def status
    @status || self.class.status
  end

  def as_json(*args)
    {
      :code    => code,
      :message => message
    }
  end
end
