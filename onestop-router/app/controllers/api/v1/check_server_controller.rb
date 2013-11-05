class Api::V1::CheckServerController < Api::V1::BaseController
  before_filter :load_system_configuration

  def show
    success_with @server_configuration
  end

  private
    def load_system_configuration
      @server_configuration = ServerConfiguration::CONFIG
    end
end
