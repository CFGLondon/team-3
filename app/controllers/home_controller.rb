class HomeController < ApplicationController
  layout "api"

  def index
    @category_id = params[:category_id]
    if @category_id.present?
      @messages = Message.where("category_id = ?", @category_id)
    else
      @messages = Message.all
    end
    @ret = {count: @messages.count, photos: []} 
    @messages.each do |m| 
      @ret[:photos] << {
        photo_id: m.id,
        photo_title: m.person.name,
        photo_url: "http://www.panoramio.com/photo/27932",
        photo_file_url: "http://www.panoramio.com/photo/27932",
        latitude: m.location.lat,
        longitude: m.location.lng,
        width: 500,
        height: 350,
        upload_date: m.person.dob.to_s,
        owner_name: m.person.name,
        owner_id: m.id,
        owner_url: "http://www.panoramio.com/photo/27932"
      }   
    end 
  end
end
