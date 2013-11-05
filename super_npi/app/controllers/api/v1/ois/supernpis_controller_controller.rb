class Api::V1::Ois::SupernpisControllerController < ApplicationController

  #
  # Pull data from NPI_MASTER, C_LEVEL_DEA and NPI_DEA_XREF
  #
  def view_user
    provider = NpiMaster.join_result(params[:npi_code])
    if provider.present?
      render :json => { :status => 200, :provider_detail => provider }
    else
      render :json => {:status => 404, :message => "Could not find requested provider." }
    end
  end

  def batch_upload_dest
    render json: { message: "" }
  end

  def view_provider
    render json: { message: "" }
  end

  def save_provider
    render json: { message: "" }
  end

  def verify_provider
  end

  def authenticate
  end
end
