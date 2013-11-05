class ExceptionsController < ApplicationController
  def raise_routing_error
    raise env['action_dispatch.exception']
  end
end
