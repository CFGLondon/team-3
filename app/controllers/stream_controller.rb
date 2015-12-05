class StreamController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    $redis.subscribe('crier:transitions') do |on|
      on.message do |event, data|
        response.stream.write "data: #{JSON.dump(data)}"
        response.stream.write "\n\n"
      end
    end
  ensure
    response.stream.close
  end
end
