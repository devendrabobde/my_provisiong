class Api::V1::Ois::EpcsController < ApplicationController
  include OnestopRouter
  include EpcsIntegration

  def batch_upload_dest
    organization       = params[:organization]
    providers          = params[:providers]
    org_setup_response = EpcsIntegration::epcs_confirm_org(organization)
    # Here we will be calling EPCS batch_idp method
    if org_setup_response.present?
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def verify_provider
    response = OnestopRouter::request_idp(provider_params)
    if response.present?
      render json: { ois_list: response }
    else
      render json: { status: 404, message: "Could not verify requested provider." }
    end
  end

  def save_provider
    response = OnestopRouter::save_provider(provider_params)
    if response.present?
      render json: response
    else
      render json: { status: 500, message: "Unable to save requested provider." }
    end
  end

  def authenticate
    render json: {message: "Here we will be calling EPCS-webservice let's call it Authenticate"}
  end

  def view_provider
    render json: {message: "Here we will be calling EPCS-webservice let's call it WSviewprovider"}
  end

  private

  def provider_params
    params.permit(:npi, :first_name, :last_name)
  end
end
