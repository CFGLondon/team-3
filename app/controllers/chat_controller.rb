class ChatController < ApplicationController
  include ActionController::Live

  skip_before_filter  :verify_authenticity_token

  def index
  end

  def pub
    $redis.publish 'chat_event', params[:chat_data].to_json
    render json: {}, status: 200
  end

  def sub
    response.headers["Content-Type"] = "text/event-stream"

    redis = Redis.new
    redis.subscribe(['chat_event']) do |on|
      on.message do |event, data|
        response.stream.write "event: #{event}\ndata: #{data}\n\n"
      end
    end
  rescue IOError
    logger.info "Stream Closed"
  ensure
    redis.quit
    response.stream.close
  end
end
