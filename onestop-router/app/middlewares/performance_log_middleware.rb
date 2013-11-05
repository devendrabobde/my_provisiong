class PerformanceLogMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @env     = env
    @request = Rack::Request.new(@env)

    if api_request?
      user_agent = UserAgent.parse(@request.user_agent)

      performance_log = PerformanceLog.new
      performance_log.request_time    = Time.now
      performance_log.request_ip      = @request.ip
      performance_log.request_content = "#{@request.request_method} #{@request.path}"
      performance_log.client_platform = user_agent.browser
      performance_log.client_version  = user_agent.version.to_s
      performance_log.request_params  = @request.params.to_json
      performance_log.request_size    = @request.body.length
      performance_log.server_name     = ServerConfiguration::CONFIG['service_name']
      performance_log.server_version  = ServerConfiguration::CONFIG['code_version']

      call_rails

      rails_route_params = env['action_dispatch.request.parameters']

      response_body = ""
      @response.each { |part| response_body += part }

      performance_log.client_id        = env['client_id']
      performance_log.response_time    = Time.now
      performance_log.response_content = response_body
      performance_log.response_size    = response_body.length
      performance_log.status           = @headers['ResponseStatus']
      performance_log.error_type       = @headers['ErrorCode']
      performance_log.error_message    = @headers['ErrorMessage']
      performance_log.controller_name  = rails_route_params['controller']
      performance_log.api_name         = rails_route_params['action']
      performance_log.save
    else
      call_rails
    end

    [@status, @headers, @response]
  end

  private
  def api_request?
    @request.path =~ /^\/api\//
  end

  def call_rails
    @status, @headers, @response = @app.call(@env)
  end
end
