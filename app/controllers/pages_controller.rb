class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @boxes = Box.openables
    @hash = Gmaps4rails.build_markers(@boxes) do |box, marker|
      marker.lat box.latitude
      marker.lng box.longitude
      # marker.infowindow render_to_string(partial: "/box/map_box", locals: { box: box })
    end
  end
end
