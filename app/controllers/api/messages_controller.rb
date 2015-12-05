class Api::MessagesController < ApplicationController
  def index
    @messages = Message.paginate(:per_page => 20, :page => params[:page]).order('created_at desc')
  end

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

  def zichen_csv
    require 'csv'
    @messages = Message.all

    file = CSV.generate do |csv|
      @messages.each do |m|
        csv << [
          m.category.keyword,
          m.location.lat,
          m.location.lng
        ]
      end
    end

    send_data file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;filename=data.csv"
  end

  def map_data
    @messages = Message.all
    ret = {count: @messages.count, photos: []}
    @messages.each do |m|
      ret[:photos] << {
        photo_id: m.id,
        photo_title: m.person.name,
        latitude: m.location.lat,
        longitude: m.location.lng,
        width: 500,
        height: 350,
        upload_date: m.person.dob.to_s,
        owner_name: m.person.name
      }
    end

    return(render json: {data: ret})
  end
end
