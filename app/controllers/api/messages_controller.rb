class Api::MessagesController < ApplicationController
  def new
    if Message.parse(params[:message])
      return(render json: { status: true })
    else
      return(render json: { status: false })
    end
  end
end
