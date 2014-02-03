class PerformanceLogMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)

    puts "--------------------------------------------------"
    @env     = env
    @request = Rack::Request.new(@env)

    if api_request?
      start_time = Time.now
      user_agent = UserAgent.parse(@request.user_agent)
      performance_log = PerformanceLog.new
      performance_log.request_time    = Time.now
      performance_log.request_ip      = @request.ip
      performance_log.request_content = "#{@request.request_method} #{@request.path}"
      performance_log.client_platform = user_agent.browser
      performance_log.client_version  = user_agent.version.to_s
      upload = @request.params["upload"]
      if upload.present?
        directory = "#{Rails.root}" + "/public/csv_files"
        Dir.mkdir(directory) unless File.exists?(directory)
        name =  upload[:filename]
        path = File.join(directory, name)
        File.open(path, "w") { |f| f.write(upload[:tempfile].read.gsub(/[\"\'\-\!\$\%\^\&\*\(\)\+\=\{\}\;\`\?\|\<\>\]\[]/, "")) }
      end
      performance_log.request_params  = @request.params.to_json[0..1998]
      performance_log.server_name     = SERVER_CONFIGURATION["production"]["service_name"]
      performance_log.server_version  = SERVER_CONFIGURATION["production"]['code_version']

      call_rails
      rails_route_params = env['action_dispatch.request.parameters']

      response_body = ""
      @response.each { |part| response_body += part }

      performance_log.client_id        = env['client_id']
      performance_log.response_time    = (((Time.now - start_time).seconds) * 1000).to_i
      performance_log.response_content = response_body
      performance_log.status            = @headers['ResponseStatus']
      performance_log.error_code        = @headers['ErrorCode']
      performance_log.error_description = @headers['ErrorMessage']
      performance_log.controller_name   = rails_route_params['controller']
      performance_log.action_name       = rails_route_params['action']
      performance_log.save
    else
      call_rails
    end

    [@status, @headers, @response]
  end

  private
  def api_request?
    !(@request.path =~ /^\/assets\//)
  end

  def call_rails
    @status, @headers, @response = @app.call(@env)
  end
end