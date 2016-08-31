class PositionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :update ]

  def update
    session[:gps] = { lat: params[:lat] , lng: params[:lng] }
    @boxes = Box.all.near([session[:gps][:lat], session[:gps][:lng]], 5).openables # 5: distance in km
    @hash = Gmaps4rails.build_markers(@boxes) do |box, marker|
      marker.lat box.latitude
      marker.lng box.longitude
      marker.title box.id.to_s
      marker.picture({
       "url" => "http://nouveau.tanas.net/box.png",
       "width" =>  32,
       "height" => 32})
    end
    render json: @hash.to_json
  end
end
