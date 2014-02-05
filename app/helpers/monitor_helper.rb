module MonitorHelper

	def display_server_status(str)
		return str unless str.eql?(false)
		"<span class='status-error'>Server is not running.</value>".html_safe
	end
end
