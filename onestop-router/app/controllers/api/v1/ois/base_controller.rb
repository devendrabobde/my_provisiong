class Api::V1::Ois::BaseController < Api::V1::BaseController
  before_filter :authenticate_ois

  def ois
    @ois
  end

  def current_user
    ois
  end

  private
    def authenticate_ois
      ois_id       = request.headers['HTTP_OISID']
      ois_password = request.headers.delete('HTTP_OISPASSWORD')

      @ois = ::Ois.authenticate(ois_id, ois_password)
    end
end
