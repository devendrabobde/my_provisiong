module MonitorHelper

	def display_server_status(str, status)
		if str.blank? || str['result'].eql?(false)
      "<span class='status-error'>Server is not running.</value>".html_safe
    else
      status
    end
	end
end
