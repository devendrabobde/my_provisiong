class PerformanceLogMiddleware

  # initialize the application
  def initialize(app)
    @app = app
  end

  # This method is responds to Rack call(), It takes exactly one argument, the environment and
  # returns an Array of exactly three values [http_status_code, response_headers_hash, body]
  def call(env)
    @env     = env
    @request = Rack::Request.new(@env)
    if api_request?
      start_time = Time.now
      user_agent = UserAgent.parse(@request.user_agent)
      performance_log = PerformanceLog.new
      performance_log.request_time    = start_time
      performance_log.request_ip      = @request.ip
      performance_log.request_content = "#{@request.request_method} #{@request.path}"
      performance_log.client_platform = user_agent.browser
      performance_log.client_version  = user_agent.version.to_s

      # if request contains csv attachment then store attached csv file on file system
      upload = @request.params["upload"]
      if upload.present?
        directory = "#{Rails.root}" + "/public/csv_files"
        Dir.mkdir(directory) unless File.exists?(directory)
        fname = upload[:filename]
        upload[:filename] = fname.chomp(File.extname(fname)) + "_" + DateTime.now.to_s + File.extname(fname)
        file_name = upload[:filename]
        path = File.join(directory, file_name)
        File.open(path, "w") { |f| f.write(upload[:tempfile].read.gsub(/[\"\'\!\$\%\^\&\*\(\)\+\=\{\}\;\`\|\<\>\]\[]/, "")) }
        size = File.size(path)
        performance_log.request_params        = @request.params.merge(file_size: size).to_json[0..1998] rescue @request.params.to_json[0..1998]
      else
        performance_log.request_params        = @request.params.to_json[0..1998]
      end
      # Read server configuration from config/server.yml file
      performance_log.server_name           = SERVER_CONFIGURATION["onestop_service_name"]
      performance_log.server_version        = SERVER_CONFIGURATION['onestop_code_version']
      performance_log.server_ip             = SERVER_CONFIGURATION['onestop_server_ip']
      performance_log.server_instance_name  = SERVER_CONFIGURATION['onestop_server_instance_name']

      call_rails

      rails_route_params = env['action_dispatch.request.parameters']

      # calculate total response body
      response_body = ""
      @response.each { |part| response_body += part }
      performance_log.client_id           = @request.ip
      response_time                       = (((Time.now - start_time).seconds) * 1000).to_i
      performance_log.response_time       = response_time
      performance_log.response_content    = response_body.to_s.truncate(2000) rescue nil
      performance_log.error_code          = @response.status rescue nil
      performance_log.error_description   = @response.status_message rescue nil
      db_response_time                    = @response.request.env['action_controller.instance'].db_runtime rescue nil
      performance_log.db_response_time    = db_response_time
      performance_log.total_response_time = response_time + db_response_time.to_i
      performance_log.controller_name     = rails_route_params['controller'] rescue nil
      performance_log.action_name         = rails_route_params['action'] rescue nil
      performance_log.save
    else
      call_rails
    end
    [@status, @headers, @response]
  end

  private

  # return true if request is for controller action o.w false
  def api_request?
    !(@request.path =~ /^\/assets\//)
  end

  # Returns an Array of [http_status_code, response_headers_hash, body]
  def call_rails
    @status, @headers, @response = @app.call(@env)
  end
end