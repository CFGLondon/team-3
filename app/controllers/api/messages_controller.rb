class Api::MessagesController < ApplicationController
  def new
    if Message.parse(params[:message])
      return(render json: { status: true })
    else
      return(render json: { status: false })
    end
  end

  def twilio
    message = params[:Body] + " PHONE " + params[:From] + " WHERE " + params[:FromCountry]
    if Message.parse message
      return(render json: { status: true })
    else
      return(render json: { status: false })
    end
  end
end
