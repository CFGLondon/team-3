class Api::MessagesController < ApplicationController
  def new
    if Message.parse(params[:message])
      return(render json: { status: true })
    else
      return(render json: { status: false })
    end
  end

  def twilio
    Message.create content: params, category_id: 10
    return(render json:{status: 1})
  end
end
