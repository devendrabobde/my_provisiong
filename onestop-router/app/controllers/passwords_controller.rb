class PasswordsController < ApplicationController
  def create
    render :text => Password.new
  end
end
